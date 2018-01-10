import Foundation
import GRDB
import Hydra
import UIKit

class ControllerManager {
  
  static var shared: ControllerManager!
  
  let serviceManager: ServiceManager
  
  init() throws {
    
    let documentDirectory = try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    let dbFilePath = documentDirectory.appendingPathComponent(ECODATUM_DATABASE_FILE_NAME)
    
    if RESET_ECODATUM_DATABASE_ON_INITIALIZAION &&
      FileManager.default.fileExists(atPath: dbFilePath.path) {
      try FileManager.default.removeItem(at: dbFilePath)
    }
    
    var configuration = Configuration()
    configuration.trace = {
      sql in
      LOG.debug(sql)
    }
    
    let databasePool = try DatabasePool(path: dbFilePath.path,
                                        configuration: configuration)
    
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
