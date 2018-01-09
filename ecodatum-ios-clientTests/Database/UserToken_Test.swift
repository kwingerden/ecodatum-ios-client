import Hydra
import XCTest
@testable import ecodatum_ios_client

class UserToken_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation()
    
    let databaseManager = try DatabaseManager(dropDatabase: true)
    async {
      _ -> () in
      
      let newUserTokenOperation = NewUserTokenOperation(userId: 1, token: "token")
      let newUserToken = try await(newUserTokenOperation.run(databaseManager))
      
      guard let newUserTokenId = newUserToken.id else {
        XCTFail()
        return
      }
      
      let userTokenExistsOperation = UserTokenExistsOperation(userToken: newUserToken)
      let userTokenExists = try await(userTokenExistsOperation.run(databaseManager))
      XCTAssertTrue(userTokenExists)
      
      let findUserTokenOperation = FindUserTokenOperation(id: newUserTokenId)
      let existingUserToken = try await(findUserTokenOperation.run(databaseManager))
      
      XCTAssert(newUserToken == existingUserToken)
      
      }.always {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)

  }
  
}

