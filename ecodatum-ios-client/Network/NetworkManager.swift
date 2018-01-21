import Foundation
import Hydra

class NetworkManager {
  
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func call(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    return try BasicAuthUserCall(
      url: baseURL.appendingPathComponent("login"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<CreateNewOrganizationUserResponse> {
    return try CreateNewUserCall(
      url: baseURL
        .appendingPathComponent("public")
        .appendingPathComponent("users"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetUserByIdRequest) throws -> Promise<GetUserByIdResponse> {
    return try GetUserByIdCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("users")
        .appendingPathComponent("\(request.userId)"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetOrganizationsByUserIdRequest) throws -> Promise<[GetOrganizationsByUserIdResponse]> {
    return try GetOrganizationsByUserIdCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("organizations"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
}
