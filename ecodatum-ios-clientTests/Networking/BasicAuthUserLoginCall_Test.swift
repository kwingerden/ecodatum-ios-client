import Foundation
import XCTest
@testable import ecodatum_ios_client

class BasicAuthUserLoginCall_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation(description: "Login Response")
    
    BasicAuthUserLoginCall(
      email: "admin@ecodatum.org",
      password: "password") {
        
        response in
        
        switch response {
        case let .error(error):
          XCTFail(error.localizedDescription)
        case let .success(userToken):
          print(userToken.token)
        }
        
        expectation.fulfill()
        
      }.run()
    
    wait(for: [expectation], timeout: 30)
    
  }
  
}


