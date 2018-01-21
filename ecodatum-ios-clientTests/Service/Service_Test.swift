import XCTest
@testable import ecodatum_ios_client

class LoginService_Test: XCTestCase {
  
  var serviceManager: ServiceManager!
  
  override func setUp() {
    super.setUp()
    do {
      serviceManager = try ServiceHelper.defaultServiceManager()
    } catch let error {
      LOG.error("\(error)")
    }
  }
  
  func test_Login() throws {
    
    let expectation = XCTestExpectation()
    
    let request = BasicAuthUserRequest(
      email: "admin@ecodatum.org",
      password: "password")
    serviceManager.call(request)
      .then(in: .main) {
        response in
        LOG.debug("SUCCESS: \(response)")
      }.catch(in: .main) {
        error in
        LOG.debug("FAILURE: \(error)")
        XCTFail()
      }.always {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
    
  }
  
  func test_CreateNewOrganizationUser() throws {
    
    let expectation = XCTestExpectation()
    
    let request = CreateNewOrganizationUserRequest(
      organizationCode: "PZZTPK",
      fullName: "Test User11",
      email: "test11@ecodatum.org",
      password: "password")
    serviceManager.call(request)
      .then(in: .main) {
        response in
        LOG.debug("SUCCESS: \(response)")
      }.catch(in: .main) {
        error in
        LOG.debug("FAILURE: \(error)")
        XCTFail()
      }.always {
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10)
    
  }
  
}

