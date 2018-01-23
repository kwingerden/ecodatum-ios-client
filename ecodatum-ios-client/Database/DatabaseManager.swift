import Foundation
import GRDB
import Hydra

class DatabaseManager {
    
  typealias DatabaseWrite = (Database) throws -> Database.TransactionCompletion
  
  typealias DatabaseRead<R> = (Database) throws -> R
  
  private var databasePool: DatabasePool
  
  private static var _shared: DatabaseManager? = nil
  
  init(_ databasePool: DatabasePool) throws {
    
    self.databasePool = databasePool
    
    try databasePool.writeInTransaction {
      db in
      try AuthenticatedUserRecord.createTable(db)
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
