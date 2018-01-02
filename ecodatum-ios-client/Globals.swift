import Foundation
import RealmSwift
import SwiftyBeaver
import SwiftyJSON

enum OperationError: Error {
  case authorizationHeader
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

// REALM

let DB: Realm = {
  
  () -> Realm? in
  
  do {
    
    let documentDirectoryURL = try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    
    let realmConfiguration = Realm.Configuration(
      fileURL: documentDirectoryURL.appendingPathComponent("eocdatum.realm"),
      readOnly: false,
      schemaVersion: 1,
      deleteRealmIfMigrationNeeded: true)
    
    return try Realm(configuration: realmConfiguration)
    
  } catch let error {
    
    LOG.error("Failed to initialize ecodatum Realm Database")
    return nil
    
  }
  
}()!

