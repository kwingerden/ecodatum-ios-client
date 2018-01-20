import Foundation
import GRDB
import Hydra
import UIKit

class ViewControllerManager {
  
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
                                           sender: Any? = nil) {
    
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
  
  func login(email: String, password: String) -> Promise<LoginResponse> {
    return serviceManager.login(
      LoginRequest(
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
    password: String) -> Promise<CreateNewAccountResponse> {
    
    return serviceManager.createNewAccount(
      CreateNewAccountRequest(
        organizationCode: organizationCode,
        fullName: fullName,
        email: email,
        password: password))
  
  }
  
}
