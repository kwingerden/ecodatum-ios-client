import XCTest
@testable import ecodatum_ios_client

class LoginService_Test: XCTestCase {
  
  func test() throws {
    
    let expectation = XCTestExpectation()
    
    let serviceManager = try ServiceHelper.defaultServiceManager()
    let email = "admin@ecodatum.org"
    let password = "password"
    
    serviceManager.login(email: email, password: password)
      .then {
        loginResponse in
        XCTAssert(!loginResponse.token.isEmpty)
      }.catch {
        error in
        XCTFail(error.localizedDescription)
      }.always {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
    
  }
  
}

