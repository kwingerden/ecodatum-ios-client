import Alamofire
import Foundation
import Hydra
import SVProgressHUD
import SwiftValidator
import UIKit

typealias AuthenticatedUser = AuthenticatedUserRecord
typealias Organization = OrganizationResponse
typealias Site = SiteResponse

class BaseViewController: UIViewController {
  
  var authenticatedUser: AuthenticatedUser? {
    do {
      return try BaseViewController.serviceManager.getAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
      return nil
    }
  }
  
  static var serviceManager: ServiceManager!
  
  let validator = Validator()
  
  private static var viewContext: Any?
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    validator.defaultStyleTransformers()
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    switch segue.destination {
      
    case is AccountViewController:
      
      let source = segue.source as! BaseViewController
      let destination = segue.destination as! AccountViewController
      destination.performSegueFrom = source
      
    case is TopNavigationViewController,
         is TopNavigationChoiceNavigationController,
         is TopNavigationChoiceViewController,
         is CreateNewSiteViewController:
      
      var destination = segue.destination as! OrganizationHolder
      destination.organization = BaseViewController.viewContext as! Organization
      
    default:
      break // do nothing
      
    }
    
  }
  
  func performSegue<T: BaseViewController>(
    from: T,
    to: ViewController,
    sender: Any? = nil,
    viewContext: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(from) => \(to)")
    BaseViewController.viewContext = viewContext
    from.performSegue(withIdentifier: to.rawValue, sender: sender)
    
  }
  
  func checkAuthenticatedUser() {
    
    if let authenticatedUser = authenticatedUser {
      
      getUserOrganizations(authenticatedUser)
        .then(in: .userInitiated, handleOrganizationChoice)
        .catch(in: .main, handleError)
      
    } else {
      
      performSegue(from: self, to: .welcome)
      
    }
    
  }
  
  func login(email: String,
             password: String) -> Promise<AuthenticatedUser> {
    
    return async(in: .userInitiated) {
      
      status in
      
      let basicAuthUserResponse = try await(
        BaseViewController.serviceManager.call(
          BasicAuthUserRequest(
            email: email,
            password: password)))
      
      let getUserResponse = try await(
        BaseViewController.serviceManager.call(
          GetUserRequest(
            userId: basicAuthUserResponse.userId,
            token: basicAuthUserResponse.token)))
      
      let authenticatedUser = AuthenticatedUserRecord(
        userId: getUserResponse.id,
        token: basicAuthUserResponse.token,
        fullName: getUserResponse.fullName,
        email: getUserResponse.email)
      try BaseViewController.serviceManager.setAuthenticatedUser(
        authenticatedUser)
      
      return authenticatedUser
      
    }
    
  }
  
  func logout() {
    
    do {
      try BaseViewController.serviceManager.deleteAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
    }
    
  }
  
  func getUserOrganizations(
    _ authenticatedUser: AuthenticatedUser) -> Promise<[Organization]> {
    
    return async(in: .userInitiated) {
      
      status in
      
      return try await(
        try BaseViewController.serviceManager.call(
          GetOrganizationsByUserRequest(token: authenticatedUser.token)))
      
    }
    
  }
  
  func handleOrganizationChoice(_ organizations: [Organization]) {
    
    if organizations.count == 1 {
      
      performSegue(
        from: self,
        to: .topNavigation,
        viewContext: organizations[0])
      
    } else if organizations.count > 1 {
      
      performSegue(
        from: self,
        to: .organizationChoice,
        viewContext: organizations)
      
    } else {
      
      LOG.error("User does not belong to any organizations.")
      
    }
    
  }
  
  func isResponseStatus(_ error: Error, status: Int) -> Bool {
    if let afError = error as? AFError,
      afError.responseCode == status {
      return true
    } else {
      return false
    }
  }
  
  func isUnauthorizedError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 401)
  }
  
  func isConflictError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 409)
  }
  
  func handleError(_ error: Error) {
    
    LOG.error(error)
    
    switch error {
      
    case AFError.responseValidationFailed(let reason):
      
      switch reason {
        
      case .unacceptableStatusCode(let code):
        
        switch code {
          
        case 401: // Unauthorized
          logout()
          performSegue(from: self, to: .welcome)
          
        default:
          SVProgressHUD.defaultShowError(error.localizedDescription)
          
        }
        
      default:
        SVProgressHUD.defaultShowError(error.localizedDescription)
        
      }
      
    default:
      SVProgressHUD.defaultShowError(error.localizedDescription)
      
    }
    
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String) -> Promise<AuthenticatedUser> {
    
    return async(in: .userInitiated) {
      
      status in
      
      let _ = try await(
        BaseViewController.serviceManager.call(
          CreateNewOrganizationUserRequest(
            organizationCode: organizationCode,
            fullName: fullName,
            email: email,
            password: password)))
      
      return try await(self.login(email: email, password: password))
      
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
        BaseViewController.serviceManager.call(
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
  
  func preAsyncUIOperation() {
    
    view.isUserInteractionEnabled = false
    if activityIndicator != nil {
      activityIndicator.startAnimating()
    }
    
  }
  
  func postAsyncUIOperation() {
    
    view.isUserInteractionEnabled = true
    if activityIndicator != nil {
      activityIndicator.stopAnimating()
    }
    
  }
  
}
