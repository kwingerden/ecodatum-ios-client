import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  override func setUp() {
    
    do {
      try DB.write {
        DB.deleteAll()
      }
    } catch let e {
      XCTFail(e.localizedDescription)
    }
    
  }
  
  func test() throws {
  
    try DB.write {
      DB.add(UserToken.make(userId: 1, token: "token"))
    }

  }
  
}

