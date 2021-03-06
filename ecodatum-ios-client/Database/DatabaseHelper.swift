import Foundation
import GRDB

class DatabaseHelper {
  
  static func defaultDatabaseDirectory() throws -> URL {
    
    let documentDirectory = try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    return documentDirectory.appendingPathComponent("EcoDatum")
    
  }
  
  static func recreateDatabaseDirectory(_ directory: URL) throws {

    do {
      try FileManager.default.removeItem(at: directory)
    } catch let error {
      LOG.warning("Failed to remove directory: \(error), \(directory.absoluteString)")
    }
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true)
  
  }
  
  static func defaultDatabaseConfiguration() -> Configuration {
    
    var configuration = Configuration()
    configuration.trace = {
      sql in
      LOG.debug(sql)
    }
    
    return configuration
    
  }
  
  static func defaultDatabasePool(_ recreateDatabaseDirectory: Bool = false)
    throws -> DatabasePool {
    
    let databaseDirectory = try DatabaseHelper.defaultDatabaseDirectory()
    if recreateDatabaseDirectory {
      let _ = try DatabaseHelper.recreateDatabaseDirectory(databaseDirectory)
    }
    let configuration = DatabaseHelper.defaultDatabaseConfiguration()
    let databaseFile = databaseDirectory.appendingPathComponent(ECODATUM_DATABASE_FILE_NAME)
      
    return try DatabasePool(path: databaseFile.absoluteString,
                            configuration: configuration)
    
  }
  
  static func defaultDatabaseManager(
    _ recreateDatabaseDirectory: Bool = false) throws -> DatabaseManager {
      return try DatabaseManager(
        DatabaseHelper.defaultDatabasePool(recreateDatabaseDirectory))
  }
  
}
