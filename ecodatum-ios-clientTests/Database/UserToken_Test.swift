import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  func test() throws {
  
    let db = try Database(dropDatabase: true)
    let userToken1 = UserTokenDB(id: 1, userId: 1, token: "token")
    try db.insert(userToken1)
    XCTAssert(try db.exists(userToken1))
    
  }
  
}

