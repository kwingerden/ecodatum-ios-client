import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  override func setUp() {
    
    do {
      
      try DB.inDatabase {
        db in
        try db.drop(table: UserToken.databaseTableName)
      }
      
      try DB.inDatabase {
        db in
        try db.create(table: UserToken.databaseTableName) {
          table in
          table.column(UserToken.Columns.id.name, .integer).primaryKey()
          table.column(UserToken.Columns.userId.name, .integer).notNull()
          table.column(UserToken.Columns.token.name, .text).notNull()
        }
      }
      
    } catch let e {
      XCTFail(e.localizedDescription)
    }
    
  }
  
  func test() throws {
  
    try DB.inDatabase {
      db in
      var userToken = UserToken(id: 1, userId: 1, token: "token")
      try userToken.insert(db)
    }

  }
  
}

