import Foundation
import Hydra

class NetworkManager {
  
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func basicAuthUserCall(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    return try BasicAuthUserCall(
      url: baseURL.appendingPathComponent("login"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func createNewUserCall(_ request: CreateNewUserRequest) throws -> Promise<CreateNewUserResponse> {
    return try CreateNewUserCall(
      url: baseURL
        .appendingPathComponent("public")
        .appendingPathComponent("users"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
}
