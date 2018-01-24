import Foundation
import XCTest
@testable import ecodatum_ios_client

class Network_Test: XCTestCase {
  
  var networkManager: NetworkManager!
  
  override func setUp() {
    super.setUp()
    networkManager = NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL)
  }
  
  func test_BasicAuthUserCall() throws {
    
    let expectation = XCTestExpectation()
    
    let request = BasicAuthUserRequest(
      email: "admin@ecodatum.org",
      password: "password")
    try networkManager.call(request)
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
    
    wait(for: [expectation], timeout: 30)
    
  }
  
  func test_CreateNewOrganizationUserCall() throws {
    
    let expectation = XCTestExpectation()
    
    let request = CreateNewOrganizationUserRequest(
      organizationCode: "PZZTPK",
      fullName: "Test User10",
      email: "test10@ecodatum.org",
      password: "password")
    try networkManager.call(request)
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
    
    wait(for: [expectation], timeout: 30)
    
  }
  
  func test_GetUserByIdCall() throws {
    
    let expectation = XCTestExpectation()
    
    let request = GetUserRequest(
      token: "AhbT31D3eWXM0tooAfLNfg==",
      userId: 5)
    try networkManager.call(request)
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
    
    wait(for: [expectation], timeout: 30)
    
  }
  
}


