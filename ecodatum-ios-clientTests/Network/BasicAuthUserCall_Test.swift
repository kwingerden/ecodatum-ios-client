import Foundation
import XCTest
@testable import ecodatum_ios_client

class BasicAuthUserCall_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation(description: "Login Response")
    
    BasicAuthUserCall(email: "admin@ecodatum.org",
                      password: "password",
                      url: ECODATUM_BASE_V1_API_URL.appendingPathComponent("login"))
      .run()
      .then(in: .main) {
        userToken in
        LOG.debug("UserToken: \(userToken)")
      }.catch(in: .main) {
        error in
        XCTFail(error.localizedDescription)
      }.always(in: .main) {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 30)
    
  }
  
}


