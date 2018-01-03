import Foundation
import GRDB

class Database {
  
  private var dbQ: DatabaseQueue
  
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
    
    dbQ = try DatabaseQueue(path: dbFilePath.path,
                            configuration: configuration)
  
    // Create Tables
    try dbQ.inDatabase {
      
      db in
      
      // UserToken
      try db.create(table: UserTokenDB.databaseTableName,
                    temporary: false,
                    ifNotExists: true) {
        table in
        table.column(UserTokenDB.Columns.id.name, .integer).primaryKey()
        table.column(UserTokenDB.Columns.userId.name, .integer).notNull()
        table.column(UserTokenDB.Columns.token.name, .text).notNull()
      }
      
    }
    
  }
  
  func insert<P: Persistable>(_ p: P) throws {
    try dbQ.inDatabase {
      db in
      try p.insert(db)
    }
  }
  
  func exists<P: Persistable>(_ p: P) throws -> Bool {
    return try dbQ.inDatabase {
      db in
      return try p.exists(db)
    }
  }
  
}
