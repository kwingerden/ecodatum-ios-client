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
  
  let id: Int // tokenId
  let token: String
  let userId: Int
  
}

struct CreateNewOrganizationUserRequest: NetworkRequest {
  
  let organizationCode: String
  let fullName: String
  let email: String
  let password: String
  
}

struct GetUserRequest: ProtectedNetworkRequest {
  
  let userId: Int
  let token: String
  
}

struct UserResponse: NetworkResponse {
  
  let id: Int // userId
  let fullName: String
  let email: String
  
}

struct GetOrganizationsByUserRequest: ProtectedNetworkRequest {
  
  let token: String
  
}

struct OrganizationResponse: NetworkResponse {
 
  let id : Int // organization id
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
  let organizationId: Int
  
}

struct GetSitesByOrganizationAndUserRequest: ProtectedNetworkRequest {
  
  let token: String
  let organizationId: Int
  
}

struct SiteResponse: NetworkResponse {
  
  let id: Int // site id
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: Int
  
}


