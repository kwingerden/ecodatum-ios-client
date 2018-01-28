import Alamofire
import Foundation
import Hydra
import SVProgressHUD
import SwiftValidator
import UIKit

typealias AuthenticatedUser = AuthenticatedUserRecord
typealias Organization = OrganizationResponse
typealias Site = SiteResponse

typealias PreAsyncBlock = () -> Void
typealias PostAsyncBlock = () -> Void

protocol ViewControllerManagerHolder {
  
  var viewControllerManager: ViewControllerManager! { get set }
  
}

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
  
  func performSegue(to: ViewController, sender: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(viewController) => \(to)")
    viewController.performSegue(withIdentifier: to.rawValue, sender: sender)
    
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
            SVProgressHUD.defaultShowError("Invalid username and/or password")
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
  
  func showOrganization(_ organization: Organization) {
    
    viewContext.state[.organization] = ViewContext.Value.organization(organization)
    performSegue(to: .topNavigation)
    
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
          SVProgressHUD.defaultShowError(error.localizedDescription)
          
        }
        
      default:
        SVProgressHUD.defaultShowError(error.localizedDescription)
        
      }
      
    case ViewControllerError.noUserOrganizations:
      logout()
      SVProgressHUD.defaultShowError("User does not belong to any organizations.")
      
    default:
      SVProgressHUD.defaultShowError(error.localizedDescription)
      
    }
    
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String) {
    
    async(in: .userInitiated) {
      
      status in
      
      let _ = try await(
        self.serviceManager.call(
          CreateNewOrganizationUserRequest(
            organizationCode: organizationCode,
            fullName: fullName,
            email: email,
            password: password)))
      
      self.login(email: email, password: password)
      
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
  
  /*
   func getUserSites(_ authenticatedUser: AuthenticatedUser) -> Promise<[Site]> {
   
   return async(in: .userInitiated) {
   
   status in
   
   return try await(
   try BaseViewController.serviceManager.call(
   GetOrganizationsByUserRequest(token: authenticatedUser.token)))
   
   }
   
   }
   */
  
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
      
      performSegue(to: .topNavigation)
      
    } else if organizations.count > 1 {
      
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
  
}


