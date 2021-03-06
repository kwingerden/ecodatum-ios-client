import Alamofire
import Foundation

typealias Base64Encoded = String

protocol NetworkRequest: Encodable {

}

extension NetworkRequest {

  func toParameters(_ jsonEncoder: JSONEncoder) -> Parameters? {

    guard let data = try? jsonEncoder.encode(self) else {
      return nil
    }
    guard let jsonObject = try? JSONSerialization.jsonObject(
      with: data,
      options: .allowFragments),
          var parameters = jsonObject as? Parameters else {
      return nil
    }

    if let _ = self as? ProtectedNetworkRequest {
      // Token is supplied in the HTTP header, not the body.
      parameters.removeValue(forKey: "token")
    }

    if parameters.isEmpty {
      return nil
    } else {
      return parameters
    }

  }

}

protocol ProtectedNetworkRequest: NetworkRequest {

  var token: AuthenticationToken { get }

}

protocol NetworkResponse: Decodable {

}

struct HttpOKResponse: Decodable {

}

struct BasicAuthUserRequest: NetworkRequest {

  let email: String
  let password: String

}

struct BasicAuthUserResponse: NetworkResponse {

  let id: Identifier // tokenId
  let token: AuthenticationToken
  let userId: String
  let isRootUser: Bool

}

struct LogoutRequest: ProtectedNetworkRequest {

  let userId: String
  let token: AuthenticationToken

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

  let userId: Identifier
  let token: AuthenticationToken

}

struct UserResponse: NetworkResponse {

  let id: Identifier // userId
  let fullName: String
  let email: String

}

struct GetOrganizationsByUserRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken

}

struct OrganizationResponse: NetworkResponse {

  let id: Identifier // organization id
  let code: String
  let name: String
  let description: String?
  let createdAt: Date
  let updatedAt: Date

}

struct GetMembersByOrganizationAndUserRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let organizationId: String

}

struct RoleResponse: NetworkResponse {

  let id: Identifier // role id
  let name: String

}

struct OrganizationMemberResponse: NetworkResponse {

  let user: UserResponse
  let role: RoleResponse

}

struct NewOrUpdateSiteRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let id: Identifier? // site id
  let organizationId: Identifier
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?

}

struct GetSitesByOrganizationAndUserRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let organizationId: Identifier

}

struct SiteResponse: NetworkResponse {

  let id: Identifier // site id
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date

}

struct DeleteSiteByIdRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let siteId: Identifier

}

struct NewOrUpdateEcoDatumRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let id: Identifier?
  let json: String
  let siteId: Identifier
  let userId: Identifier

}

struct EcoDatumResponse: NetworkResponse {

  let id: Identifier // ecodatum id
  let siteId: Identifier
  let userId: Identifier
  let json: String
  let createdAt: Date
  let updatedAt: Date

}

struct GetEcoDataBySiteAndUserRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let siteId: Identifier

}

struct DeleteEcoDatumByIdRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let ecoDatumId: Identifier

}



