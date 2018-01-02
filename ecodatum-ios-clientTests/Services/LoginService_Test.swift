import XCTest
@testable import ecodatum_ios_client

class LoginService_Test: XCTestCase {
  
  func test() throws {
  
    let loginResponseExpectation = XCTestExpectation(description: "Login Response")
    
    let email = "admin@ecodatum.org"
    let password = "password"
    
    let loginService = LoginService(baseURL: ECODATUM_BASE_URL)
    let loginRequest = LoginService.LoginRequest(email: email, password: password)
    
    func responseHandler(loginResponse: LoginService.LoginResponse) {
      
      switch loginResponse {
      case let .failure(error):
        XCTFail(error.localizedDescription)
      case let .success(userToken):
        XCTAssert(userToken.id > 0)
        XCTAssert(!userToken.token.isEmpty)
        XCTAssert(userToken.userId == 1)
      }
      
      loginResponseExpectation.fulfill()
    
    }
    
    try loginService.login(request: loginRequest, responseHandler: responseHandler)
  
    wait(for: [loginResponseExpectation], timeout: 10)
    
  }
  
}

