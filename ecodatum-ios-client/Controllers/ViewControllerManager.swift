import Foundation
import GRDB
import Hydra
import UIKit

class ViewControllerManager {
  
  private struct SegueContext {
    let viewController: UIViewController
    let from: ViewController
    let to: ViewController
    let context: Any?
    let sender: Any?
  }
  
  private var currentContext: SegueContext? = nil
  
  private let serviceManager: ServiceManager
  
  init() throws {
    
    let databasePool = try DatabaseHelper.defaultDatabasePool(
      DROP_AND_RECREATE_ECODATUM_DATABASE_FILE)
    serviceManager = ServiceManager(
      databaseManager: try DatabaseManager(databasePool),
      networkManager: NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL))
    
  }
  
  func performSegue(_ viewController: UIViewController,
                    from: ViewController,
                    to: ViewController,
                    context: Any? = nil,
                    sender: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(from) => \(to)")
    
    currentContext = SegueContext(viewController: viewController,
                                  from: from,
                                  to: to,
                                  context: context,
                                  sender: sender)
    
    viewController.performSegue(withIdentifier: to.rawValue,
                                sender: sender)
    
  }
  
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let context = currentContext {
      LOG.debug("ViewControllerManager.prepare: \(context.from) => \(context.to)")
    } else {
      LOG.debug("ViewControllerManager.prepare: No Context")
    }
  }
  
  func login(email: String, password: String) -> Promise<LoginResponse> {
    return serviceManager.login(
      LoginRequest(
        email: email,
        password: password))
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
