import Foundation
import GRDB
import Hydra
import UIKit

class ControllerManager {
  
  static var shared: ControllerManager!
  
  let serviceManager: ServiceManager
  
  init() throws {
    
    let databasePool = try DatabaseHelper.defaultDatabasePool(
      DROP_AND_RECREATE_ECODATUM_DATABASE_FILE)
    serviceManager = ServiceManager(
      databaseManager: try DatabaseManager(databasePool),
      networkManager: NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL))
    
  }
  
  func login(email: String, password: String) -> Promise<LoginResponse> {
    return serviceManager.login(
      email: email,
      password: password)
  }
  
}
