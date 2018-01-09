import Foundation
import XCTest
@testable import ecodatum_ios_client

class BasicAuthUserCall_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation(description: "Login Response")
    
    let userLoginCall = BasicAuthUserCall(email: "admin@ecodatum.org",
                                               password: "password")
    userLoginCall.run()
      .then(in: .main) {
        userToken in
        print(userToken)
      }.catch(in: .main) {
        error in
        print(error)
        XCTFail()
      }.always(in: .main) {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 30)
    
  }
  
}


