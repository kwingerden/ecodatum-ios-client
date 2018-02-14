import Alamofire
import Foundation
import Hydra

class NetworkManager {
  
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func call(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL.appendingPathComponent("login"),
        method: .post,
        headers: Request.basicAuthHeaders(
          email: request.email,
          password: request.password),
        request: request))
  }
  
  func call(_ request: LogoutRequest) throws -> Promise<LogoutResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("logout"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<UserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("users"),
        method: .post,
        parameters: request.parameters,
        request: request))
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<UserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("users")
          .appendingPathComponent("\(request.userId)"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetOrganizationsByUserRequest) throws -> Promise<[OrganizationResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("organizations"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: CreateNewSiteRequest) throws -> Promise<SiteResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("sites"),
        method: .post,
        parameters: request.parameters,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetSitesByOrganizationAndUserRequest) throws -> Promise<[SiteResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("organizations")
          .appendingPathComponent("\(request.organizationId)")
          .appendingPathComponent("sites"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetAbioticFactorsRequest) throws -> Promise<[AbioticFactorResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("abioticFactors"),
        request: request))
  }
  
  func call(_ request: GetMeasurementUnitsByAbioticFactorIdRequest)
    throws -> Promise<[MeasurementUnitResponse]> {
      return try executeDataRequest(
        makeDataRequest(
          baseURL
            .appendingPathComponent("public")
            .appendingPathComponent("abioticFactors")
            .appendingPathComponent("\(request.id)")
            .appendingPathComponent("measurementUnits"),
          request: request))
  }
  
  private func makeDataRequest(
    _ url: URL,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = JSONEncoding.default,
    headers: HTTPHeaders? = Request.defaultHeaders(),
    request: NetworkRequest)
    -> DataRequest {
      
      return Alamofire.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers)
      
  }
  
  private func executeDataRequest<T: Decodable>(
    _ dataRequest: DataRequest)
    throws -> Promise<T> {
      
      LOG.debug(dataRequest.debugDescription)
      
      return Promise<T>(in: .userInitiated) {
        
        resolve, reject, status in
        
        dataRequest.validate(statusCode: [200]).responseData {
          
          response in
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(
                T.self,
                from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
      }
  }
  
}
