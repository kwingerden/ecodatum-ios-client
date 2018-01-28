import Alamofire
import Foundation
import Hydra
import SwiftValidator
import UIKit

typealias AuthenticatedUser = AuthenticatedUserRecord
typealias Organization = OrganizationResponse
typealias Site = SiteResponse

typealias PreAsyncBlock = () -> Void
typealias PostAsyncBlock = () -> Void

class ViewControllerManager {
  
  private let viewController: UIViewController
  
  private let viewContext: ViewContext
  
  private let serviceManager: ServiceManager
  
  lazy var authenticatedUser: AuthenticatedUser? = {
    do {
      return try serviceManager.getAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
      return nil
    }
  }()
  
  var organization: Organization? {
    guard let value = viewContext.state[.organization] else { return nil }
    if case let ViewContext.Value.organization(organization) = value {
      return organization
    } else {
      return nil
    }
  }
  
  var organizations: [Organization] {
    guard let value = viewContext.state[.organizations] else { return [] }
    if case let ViewContext.Value.organizations(organizations) = value {
      return organizations
    } else {
      return []
    }
  }
  
  init(viewController: UIViewController,
       viewContext: ViewContext,
       serviceManager: ServiceManager) {
    self.viewController = viewController
    self.viewContext = viewContext
    self.serviceManager = serviceManager
  }
  
  convenience init(newViewController: UIViewController,
                   viewControllerManager: ViewControllerManager) {
    self.init(viewController: newViewController,
              viewContext: viewControllerManager.viewContext,
              serviceManager: viewControllerManager.serviceManager)
  }
  
  func performSegue(from: UIViewController? = nil,
                    to: ViewController,
                    sender: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(viewController) => \(to)")
    (from ?? viewController).performSegue(
      withIdentifier: to.rawValue,
      sender: sender)
    
  }
  
  func main() {
    
    if let authenticatedUser = authenticatedUser {
      
      getUserOrganizations(authenticatedUser)
        .then(in: .userInitiated, handleOrganizations)
        .catch(in: .main, handleError)
      
    } else {
      
      performSegue(to: .welcome)
      
    }
    
  }
  
  func login(email: String,
             password: String,
             preAsyncBlock: PreAsyncBlock? = nil,
             postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        BasicAuthUserRequest(
          email: email,
          password: password))
        .then(in: .userInitiated, handleBasicAuthUser)
        .then(in: .userInteractive, getUserOrganizations)
        .then(in: .main, handleOrganizations)
        .catch(in: .main) {
          error in
          if self.isUnauthorizedError(error) {
            self.showErrorMessage(
              "Login Failure",
              "Invalid username and/or password.")
          } else {
            self.handleError(error)
          }
        }
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func logout() {
    
    do {
      try serviceManager.deleteAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
    }
    
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        CreateNewOrganizationUserRequest(
          organizationCode: organizationCode,
          fullName: fullName,
          email: email,
          password: password))
        .then(in: .userInitiated) {
          _ in
          try self.handleCreateNewAccount(
            email: email,
            password: password)
        }.then(in: .userInitiated, handleBasicAuthUser)
        .then(in: .userInitiated, getUserOrganizations)
        .then(in: .main, handleOrganizations)
        .catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func createNewSite(
    token: String,
    organizationId: Int,
    name: String,
    description: String? = nil,
    latitude: Double,
    longitude: Double,
    altitude: Double? = nil,
    horizontalAccuracy: Double? = nil,
    verticalAccuracy: Double? = nil) -> Promise<Site> {
    
    return async(in: .userInitiated) {
      
      status in
      
      return try await(
        self.serviceManager.call(
          CreateNewSiteRequest(
            token: token,
            name: name,
            description: description,
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            organizationId: organizationId)))
      
    }
    
  }
  
  private func isResponseStatus(_ error: Error, status: Int) -> Bool {
    if let afError = error as? AFError,
      afError.responseCode == status {
      return true
    } else {
      return false
    }
  }
  
  private func isUnauthorizedError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 401)
  }
  
  private func isConflictError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 409)
  }
  
  private func handleError(_ error: Error) {
    
    LOG.error(error.localizedDescription)
    
    switch error {
      
    case AFError.responseValidationFailed(let reason):
      
      switch reason {
        
      case .unacceptableStatusCode(let code):
        
        switch code {
          
        case 401: // Unauthorized
          logout()
          performSegue(to: .main)
          
        default:
          showErrorMessage("Unexpected Error", error.localizedDescription)
          
        }
        
      default:
        showErrorMessage("Unexpected Error", error.localizedDescription)
        
      }
      
    case ViewControllerError.noUserOrganizations:
      logout()
      showErrorMessage("No Organizations", "User does not belong to any organizations.")
      
    default:
      showErrorMessage("Unexpected Error", error.localizedDescription)
      
    }
    
  }
  
  private func showErrorMessage(_ title: String, _ message: String) {
    
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    alertController.addAction(
      UIAlertAction(
        title: "OK",
        style: UIAlertActionStyle.default,
        handler: nil))
    
    viewController.present(
      alertController,
      animated: true,
      completion: nil)
  
  }
  
  private func getUserOrganizations(_ authenticatedUser: AuthenticatedUser) -> Promise<[Organization]> {
    
    return async(in: .userInitiated) {
      
      status in
      
      return try await(
        self.serviceManager.call(
          GetOrganizationsByUserRequest(
            token: authenticatedUser.token)))
      
    }
    
  }
  
  private func handleOrganizations(_ organizations: [Organization]) throws {
    
    if organizations.count == 1 {
      
      viewContext.state[.organizations] = ViewContext.Value.organizations(organizations)
      viewContext.state[.organization] = ViewContext.Value.organization(organizations[0])
      performSegue(to: .topNavigation)
      
    } else if organizations.count > 1 {
      
      viewContext.state[.organizations] = ViewContext.Value.organizations(organizations)
      performSegue(to: .organizationChoice)
      
    } else {
      
      throw ViewControllerError.noUserOrganizations
      
    }
    
  }
  
  private func handleBasicAuthUser(
    _ basicAuthUserResponse: BasicAuthUserResponse) -> Promise<AuthenticatedUser> {
    
    return async(in: .userInitiated) {
      
      status in
      
      let userResponse = try await(
        try self.serviceManager.call(
          GetUserRequest(
            userId: basicAuthUserResponse.userId,
            token: basicAuthUserResponse.token)))
      
      let authenticatedUser = AuthenticatedUserRecord(
        userId: userResponse.id,
        token: basicAuthUserResponse.token,
        fullName: userResponse.fullName,
        email: userResponse.email)
      try self.serviceManager.setAuthenticatedUser(authenticatedUser)
      
      return authenticatedUser
      
    }
    
  }
  
  private func handleCreateNewAccount(
    email: String,
    password: String)
    throws -> Promise<BasicAuthUserResponse> {
      
      return try serviceManager.call(
        BasicAuthUserRequest(
          email: email,
          password: password))
      
  }
  
}


