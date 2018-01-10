import Foundation

class ServiceHelper {
  
  static func defaultServiceManager(_ recreateDatabaseDirectory: Bool = false)
    throws -> ServiceManager {
    let databaseManager = try DatabaseHelper.defaultDatabaseManager(recreateDatabaseDirectory)
    let networkManager = try NetworkHelper.defaultNetworkManager()
    return ServiceManager(databaseManager: databaseManager,
                          networkManager: networkManager)
  }
  
}


