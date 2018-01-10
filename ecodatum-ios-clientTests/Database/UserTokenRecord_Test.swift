import Hydra
import XCTest
@testable import ecodatum_ios_client

class UserTokenRecord_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation()
    
    let databaseManager = try DatabaseHelper.defaultDatabaseManager(true)
    async {
      _ -> () in
      
      let newUserToken = try await(
        databaseManager.newUserToken(userId: 1, token: "token"))
      guard let newUserTokenId = newUserToken.id else {
        XCTFail()
        return
      }
      
      let doesUserTokenExist = try await(
        databaseManager.doesUserTokenExist(byId: newUserTokenId))
      XCTAssertTrue(doesUserTokenExist)
      
      let existingUserToken = try await(databaseManager.findUserToken(byId: newUserTokenId))
      XCTAssert(newUserToken == existingUserToken)
    
      }.always {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)

  }
  
}

