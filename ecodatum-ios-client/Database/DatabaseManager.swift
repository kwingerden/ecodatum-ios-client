import Foundation
import GRDB

class DatabaseManager {
  
  typealias DB_ID_TYPE = Int64
  
  typealias DatabaseWrite = (Database) throws -> Database.TransactionCompletion
  
  typealias DatabaseRead<R> = (Database) throws -> R
  
  private var databasePool: DatabasePool
  
  init(dropDatabase: Bool = false) throws {
    
    let fm = FileManager.default
    
    let documentDirectory = try fm.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    let dbFilePath = documentDirectory.appendingPathComponent("ecodatum.sqlite")
    
    if dropDatabase && fm.fileExists(atPath: dbFilePath.path) {
      try fm.removeItem(at: dbFilePath)
    }
    
    var configuration = Configuration()
    configuration.trace = {
      LOG.debug($0)
    }
    
    databasePool = try DatabasePool(path: dbFilePath.path,
                                    configuration: configuration)
    
    try databasePool.writeInTransaction {
      db in
      try UserTokenRecord.createTable(db)
      return .commit
    }
    
  }
  
  func write(_ write: DatabaseWrite) throws {
    try databasePool.writeInTransaction {
      db in
      return try write(db)
    }
  }
  
  func read<R>(_ read: DatabaseRead<R>) throws -> R {
    return try databasePool.read {
      db in
      return try read(db)
    }
  }
  
}
