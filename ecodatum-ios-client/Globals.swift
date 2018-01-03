import Foundation
import GRDB
import SwiftyBeaver
import SwiftyJSON

enum NetworkingError: Error {
  case authorizationHeaderEncodingError
  case invalidCredentialStorage
  case invalidURL
}

// LOG

let LOG: SwiftyBeaver.Type = {
  
  let log = SwiftyBeaver.self
  let console = ConsoleDestination()
  let cloud = SBPlatformDestination(
    appID: SWIFTY_BEAVER_APP_ID,
    appSecret: SWIFTY_BEAVER_APP_SECRET,
    encryptionKey: SWIFTY_BEAVER_ENCRYPTION_KEY)
  
  log.addDestination(console)
  log.addDestination(cloud)
  
  return log
  
}()

// GRDB

let DB: DatabaseQueue = {
  
  () -> DatabaseQueue? in
  
  do {
    
    let applicationSupportDirectory = try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    let sqliteFile = applicationSupportDirectory.appendingPathComponent("ecodatum.sqlite")
    
    var configuration = Configuration()
    configuration.trace = {
      LOG.debug($0)
    }
    
    return try DatabaseQueue(
      path: sqliteFile.absoluteString,
      configuration: configuration)
    
  } catch let error {
    
    LOG.error("Failed to initialize ecodatum database: \(error)")
    return nil
    
  }
  
}()!

