import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  func test() throws {
  
    let db = try Database(dropDatabase: true)
    let userToken1 = UserTokenRecord(userId: 1, token: "token")
    try db.insert(userToken1)
    XCTAssert(try db.exists(userToken1))
    let tempUserToken = try db.fetch(UserTokenRecord.self, key: 1)!
    XCTAssert(userToken1 == tempUserToken)
    
  }
  
}

