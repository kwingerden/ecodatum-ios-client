import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  func test() throws {
  
    let dbMgr = try DatabaseManager(dropDatabase: true)
    let userToken1 = UserTokenRecord(userId: 1, token: "token")
    
    try dbMgr.write {
      db in
      try userToken1.insert(db)
      return .commit
    }
    
    let doesExist = try dbMgr.read {
      db in
      return try userToken1.exists(db)
    }
    
    XCTAssert(doesExist)
    
    let result = try dbMgr.read {
      db in
      return try UserTokenRecord.fetchOne(db, key: 1)
    }
    
    XCTAssert(result == userToken1)
    
  }
  
}

