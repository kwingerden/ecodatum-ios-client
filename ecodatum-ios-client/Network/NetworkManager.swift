import Alamofire
import Foundation
import Hydra

class NetworkManager {
  
  private let baseURL: URL
  
  private let jsonDecoder = JSONDecoder()
  
  private let emptyJsonData = "{}".data(using: String.Encoding.utf8)!
  
  init(baseURL: URL) {
    self.baseURL = baseURL
    jsonDecoder.dateDecodingStrategy = .customISO8601
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
  
  func call(_ request: NewOrUpdateSiteRequest) throws -> Promise<SiteResponse> {
    
    let method: HTTPMethod = request.id == nil ? .post : .put
    var url = baseURL
      .appendingPathComponent("protected")
      .appendingPathComponent("sites")
    if method == .put,
      let id = request.id {
      url = url.appendingPathComponent("\(id)")
    }
    
    return try executeDataRequest(
      makeDataRequest(
        url,
        method: method,
        parameters: request.parameters,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  
  }
  
  func call(_ request: DeleteSiteByIdRequest) throws -> Promise<HttpOKResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("sites")
          .appendingPathComponent("\(request.siteId)"),
        method: .delete,
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
  
  func call(_ request: StartNewSurveyRequest) throws -> Promise<SurveyResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("surveys"),
        method: .post,
        parameters: request.parameters,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetSurveysBySiteAndUserRequest) throws -> Promise<[SurveyResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("sites")
          .appendingPathComponent("\(request.siteId)")
          .appendingPathComponent("surveys"),
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
  
  func call(_ request: GetMeasurementUnitsByAbioticFactorRequest)
    throws -> Promise<[MeasurementUnitResponse]> {
      return try executeDataRequest(
        makeDataRequest(
          baseURL
            .appendingPathComponent("public")
            .appendingPathComponent("abioticFactors")
            .appendingPathComponent("\(request.abioticFactorId)")
            .appendingPathComponent("measurementUnits"),
          request: request))
  }
  
  func call(_ request: AddNewMeasurementRequest)
    throws -> Promise<MeasurementResponse> {
      return try executeDataRequest(
        makeDataRequest(
          baseURL
            .appendingPathComponent("protected")
            .appendingPathComponent("measurements"),
          method: .post,
          parameters: request.parameters,
          headers: Request.bearerTokenAuthHeaders(request.token),
          request: request))
  }
  
  func call(_ request: GetMeasurementsBySurveyRequest) throws -> Promise<[MeasurementResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("surveys")
          .appendingPathComponent("\(request.surveyId)")
          .appendingPathComponent("measurements"),
        headers: Request.bearerTokenAuthHeaders(request.token),
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
            
            var _data = data
            if data.count == 0 {
              _data = self.emptyJsonData
            }
            
            do {
            
              let response = try self.jsonDecoder.decode(
                T.self,
                from: _data)
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
