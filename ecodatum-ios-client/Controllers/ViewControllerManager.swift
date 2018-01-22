import Foundation
import Hydra
import UIKit

class ViewControllerManager {
  
  var currentToken: String?
  
  var currentOrganizationId: Int?
  
  private var context: Any?
  
  private let serviceManager: ServiceManager
  
  init() throws {
    
    let databasePool = try DatabaseHelper.defaultDatabasePool(
      DROP_AND_RECREATE_ECODATUM_DATABASE_FILE)
    serviceManager = ServiceManager(
      databaseManager: try DatabaseManager(databasePool),
      networkManager: NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL))
    
  }
  
  func performSegue<T: BaseViewController>(from: T,
                                           to: ViewController,
                                           sender: Any? = nil,
                                           context: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(from) => \(to)")
    self.context = context
    from.performSegue(withIdentifier: to.rawValue, sender: sender)
    
  }
  
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
      
    case is AccountViewController:
      
      let source = segue.source as! BaseViewController
      let destination = segue.destination as! AccountViewController
      destination.performSegueFrom = source
      
    case is TopNavigationViewController:
      
      let loginResponse = self.context as! LoginResponse
      let destination = segue.destination as! TopNavigationViewController
      destination.loginResponse = loginResponse
      currentToken = loginResponse.basicAuthUserResponse.token
      if let organizationId = loginResponse.firstOrganization?.id {
        currentOrganizationId = organizationId
      }
      
    default:
      break // do nothing
      
    }
  }
  
  struct LoginResponse {
    let basicAuthUserResponse: BasicAuthUserResponse
    let getUserByIdResponse: GetUserByIdResponse
    let getOrganizationsByUserIdResponse: [GetOrganizationsByUserIdResponse]
    
    var firstOrganization: GetOrganizationsByUserIdResponse? {
      if getOrganizationsByUserIdResponse.isEmpty {
        return nil
      } else {
        return getOrganizationsByUserIdResponse[0]
      }
    }
    
  }
  
  func login(email: String, password: String) -> Promise<LoginResponse> {
    
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
      
      let getOrganizationsByUserIdResponse = try await(
        self.serviceManager.call(
          GetOrganizationsByUserIdRequest(
            token: basicAuthUserResponse.token,
            userId: basicAuthUserResponse.userId)))
      
      return LoginResponse(
        basicAuthUserResponse: basicAuthUserResponse,
        getUserByIdResponse: getUserByIdResponse,
        getOrganizationsByUserIdResponse: getOrganizationsByUserIdResponse)
      
    }
    
  }
  
  func logout() {
    // TODO: need to clear out logged in state
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String) -> Promise<LoginResponse> {
    
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
      
      let getOrganizationsByUserIdResponse = try await(
        self.serviceManager.call(
          GetOrganizationsByUserIdRequest(
            token: basicAuthUserResponse.token,
            userId: basicAuthUserResponse.userId)))
      
      return LoginResponse(
        basicAuthUserResponse: basicAuthUserResponse,
        getUserByIdResponse: getUserByIdResponse,
        getOrganizationsByUserIdResponse: getOrganizationsByUserIdResponse)
      
    }
    
  }
  
  func createNewSite(
    name: String,
    description: String? = nil,
    latitude: Double,
    longitude: Double,
    altitude: Double? = nil,
    horizontalAccuracy: Double? = nil,
    verticalAccuracy: Double? = nil) -> Promise<CreateNewSiteResponse> {
    
    return serviceManager.call(CreateNewSiteRequest(
      token: currentToken!,
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      horizontalAccuracy: horizontalAccuracy,
      verticalAccuracy: verticalAccuracy,
      organizationId: currentOrganizationId!))
    
  }
  
}
