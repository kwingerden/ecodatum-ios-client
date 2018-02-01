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
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<UserResponse> {
    return try CreateNewOrganizationUserCall(
      url: baseURL
        .appendingPathComponent("public")
        .appendingPathComponent("users"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<UserResponse> {
    return try GetUserCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("users")
        .appendingPathComponent("\(request.userId)"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetOrganizationsByUserRequest)
    throws -> Promise<[OrganizationResponse]> {
    return try GetOrganizationsByUserCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("organizations"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: CreateNewSiteRequest) throws -> Promise<SiteResponse> {
    return try CreateNewSiteCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("sites"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetSitesByOrganizationAndUserRequest)
    throws -> Promise<[SiteResponse]> {
    return try GetSitesByOrganizationAndUserCall(
      url: baseURL
        .appendingPathComponent("protected")
        .appendingPathComponent("organizations")
        .appendingPathComponent("\(request.organizationId)")
        .appendingPathComponent("sites"),
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func call(_ request: GetAbioticFactorsRequest)
    throws -> Promise<[AbioticFactorResponse]> {
      return try GetAbioticFactorsCall(
        url: baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("abioticFactors"),
        invalidationToken: InvalidationToken())
        .run(request)
  }
  
  func call(_ request: GetMeasurementUnitsByAbioticFactorIdRequest)
    throws -> Promise<[MeasurementUnitResponse]> {
      return try GetMeasurementUnitsByAbioticFactorIdCall(
        url: baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("abioticFactors")
          .appendingPathComponent("\(request.id)")
          .appendingPathComponent("measurementUnits"),
        invalidationToken: InvalidationToken())
        .run(request)
  }
  
}
