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

struct CreateNewOrganizationUserResponse: NetworkResponse {
  
  let id: Int // userId
  let fullName: String
  let email: String
  
}

struct GetUserByIdRequest: ProtectedNetworkRequest {
  
  let token: String
  let userId: Int
  
}

struct GetUserByIdResponse: NetworkResponse {
  
  let fullName: String
  let email: String
  
}

struct GetOrganizationsByUserIdRequest: ProtectedNetworkRequest {
  
  let token: String
  let userId: Int
  
}

struct GetOrganizationsByUserIdResponse: NetworkResponse {
 
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

struct CreateNewSiteResponse: NetworkResponse {
  
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


