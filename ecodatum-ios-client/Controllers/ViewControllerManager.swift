import Foundation
import GRDB
import Hydra
import UIKit

class ViewControllerManager {
  
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
      
    default:
      break // do nothing
    
    }
  }
  
  func login(email: String, password: String) -> Promise<BasicAuthUserResponse> {
    return serviceManager.call(
      BasicAuthUserRequest(
        email: email,
        password: password))
  }
  
  func logout() {
    // TODO: need to clear out logged in state
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String) -> Promise<CreateNewOrganizationUserResponse> {
    
    return serviceManager.call(
      CreateNewOrganizationUserRequest(
        organizationCode: organizationCode,
        fullName: fullName,
        email: email,
        password: password))
  
  }
  
}
