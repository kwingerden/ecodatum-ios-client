import Foundation

protocol NetworkRequest: Encodable {
  
}

protocol ProtectedNetworkRequest: NetworkRequest {
 
  var token: String { get }
  
}

protocol NetworkResponse: Decodable {
  
}

struct BasicAuthUserRequest: NetworkRequest {
  
  let email: String
  let password: String
  
}

struct BasicAuthUserResponse: NetworkResponse {
  
  let id: String // tokenId
  let token: String
  let userId: String
  
}

struct LogoutRequest: ProtectedNetworkRequest {
  
  let userId: String
  let token: String
  
}

struct LogoutResponse: NetworkResponse {
  
}

struct CreateNewOrganizationUserRequest: NetworkRequest {
  
  let organizationCode: String
  let fullName: String
  let email: String
  let password: String
  
}

struct GetUserRequest: ProtectedNetworkRequest {
  
  let userId: String
  let token: String
  
}

struct UserResponse: NetworkResponse {
  
  let id: String // userId
  let fullName: String
  let email: String
  
}

struct GetOrganizationsByUserRequest: ProtectedNetworkRequest {
  
  let token: String
  
}

struct OrganizationResponse: NetworkResponse {
 
  let id : String // organization id
  let code: String
  let name: String
  let description: String?
  
}

struct CreateNewSiteRequest: ProtectedNetworkRequest {
  
  let token: String
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  
}

struct GetSitesByOrganizationAndUserRequest: ProtectedNetworkRequest {
  
  let token: String
  let organizationId: String
  
}

struct SiteResponse: NetworkResponse {
  
  let id: String // site id
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  
}

struct GetAbioticFactorsRequest: NetworkRequest {
  
}

struct AbioticFactorResponse: NetworkResponse {

  let id: String
  let name: String
  
}

struct GetMeasurementUnitsByAbioticFactorIdRequest: NetworkRequest {
  
  let id: String
  
}

struct MeasurementUnitResponse: NetworkResponse {
  
  let id: String
  let name: String
  
}

struct AddNewSiteMeasurementRequest: ProtectedNetworkRequest {
  
  let token: String
  let siteId: String
  let organizationId: String

}
