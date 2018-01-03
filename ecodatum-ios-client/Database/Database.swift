import Foundation
import GRDB

class Database {
  
  private var dbPool: DatabasePool
  
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
    
    dbPool = try DatabasePool(path: dbFilePath.path,
                          configuration: configuration)
    
    try dbPool.writeInTransaction {
      db in
      try UserTokenRecord.createTable(db)
      return .commit
    }
    
  }
  
  func insert<R: Record>(_ r: R) throws {
    try dbPool.writeInTransaction {
      db in
      try r.insert(db)
      return .commit 
    }
  }
  
  func exists<R: Record>(_ r: R) throws -> Bool {
    return try dbPool.read {
      db in
      return try r.exists(db)
    }
  }
  
  func fetch<R: Record>(_ r: R.Type, key: Int64) throws -> R? {
    return try dbPool.read {
      db in
      return try r.fetchOne(db, key: key)
    }
  }
  
}
