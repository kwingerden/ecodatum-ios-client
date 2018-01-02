import Foundation
import XCTest
@testable import ecodatum_ios_client

class BasicAuthUserLoginCall_Test: XCTestCase {
  
  struct UserToken: Decodable {
    let id: Int
    let token: String
    let userId: Int
  }
  
  func test() throws {
    
    let expectation = XCTestExpectation(description: "Login Response")
    
    BasicAuthUserLoginCall(
      email: "admin@ecodatum.org",
      password: "password") {
        
        userToken, error in
        
        if let error = error {
          XCTFail(error.localizedDescription)
        } else if let userToken = userToken {
          print(userToken)
        } else {
          XCTFail("Unexpected response.")
        }
        
        expectation.fulfill()
        
      }.run()
    
    wait(for: [expectation], timeout: 30)
    
  }
  
}


