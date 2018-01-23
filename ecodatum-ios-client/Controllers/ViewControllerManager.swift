import Foundation
import Hydra
import UIKit

class ViewControllerManager {
  
  var authenticatedUser: AuthenticatedUserRecord? {
    do {
      return try serviceManager.getAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
      return nil
    }
  }
  
  private let serviceManager: ServiceManager
  
  init() throws {
    
    let databasePool = try DatabaseHelper.defaultDatabasePool(
      DROP_AND_RECREATE_ECODATUM_DATABASE_FILE)
    let databaseManager = try DatabaseManager(databasePool)
    let networkManager = NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL)
    serviceManager = ServiceManager(
      databaseManager: databaseManager,
      networkManager: networkManager)
    
  }
  
  func performSegue<T: BaseViewController>(from: T,
                                           to: ViewController,
                                           sender: Any? = nil,
                                           context: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(from) => \(to)")
    from.performSegue(withIdentifier: to.rawValue, sender: sender)
    
  }
  
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.destination {
      
    case is AccountViewController:
      
      let source = segue.source as! BaseViewController
      let destination = segue.destination as! AccountViewController
      destination.performSegueFrom = source
      
    default:
      break // do nothing
      
    }
    
  }
  
  func login(email: String, password: String) -> Promise<AuthenticatedUserRecord> {
    
    return async(
    in: .userInitiated) {
      
      status in
      
      let basicAuthUserResponse = try await(
        self.serviceManager.call(
          BasicAuthUserRequest(
            email: email,
            password: password)))
      
      let getUserByIdResponse = try await(
        self.serviceManager.call(
          GetUserByIdRequest(
            token: basicAuthUserResponse.token,
            userId: basicAuthUserResponse.userId)))
      
      let authenticatedUser = AuthenticatedUserRecord(
        userId: basicAuthUserResponse.userId,
        token: basicAuthUserResponse.token,
        fullName: getUserByIdResponse.fullName,
        email: getUserByIdResponse.email)
      try self.serviceManager.setAuthenticatedUser(authenticatedUser)
      
      return authenticatedUser
      
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
    password: String) -> Promise<AuthenticatedUserRecord> {
    
    return async(
    in: .userInitiated) {
      
      status in
      
      let _ = try await(
        self.serviceManager.call(
          CreateNewOrganizationUserRequest(
            organizationCode: organizationCode,
            fullName: fullName,
            email: email,
            password: password)))
      
      return try await(self.login(email: email, password: password))
      
    }
    
  }
  
  typealias Organization = GetOrganizationsByUserIdResponse
  func getUserOrganizations(
    token: String,
    userId: Int) throws -> Promise<[Organization]> {
    return try serviceManager.call(
      GetOrganizationsByUserIdRequest(token: token,userId: userId))
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
    verticalAccuracy: Double? = nil) throws -> Promise<CreateNewSiteResponse> {
    
    return try serviceManager.call(
      CreateNewSiteRequest(
        token: token,
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        horizontalAccuracy: horizontalAccuracy,
        verticalAccuracy: verticalAccuracy,
        organizationId: organizationId))
    
  }
  
}
