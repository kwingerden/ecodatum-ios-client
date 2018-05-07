import Foundation

typealias Identifier = String
typealias AuthenticationToken = String
typealias Base64Encoded = String

struct User {

  let id: Identifier
  let fullName: String
  let email: String

}

struct Role {

  let id : Identifier
  let name: String

}

struct AuthenticatedUser {

  let userId: Identifier
  let token: AuthenticationToken
  let fullName: String
  let email: String
  let isRootUser: Bool

}

struct Organization {

  let id : Identifier
  let code: String
  let name: String
  let description: String?
  let createdAt: Date
  let updatedAt: Date

}

struct OrganizationMember {

  let user: User
  let role: Role

}

struct Site {

  let id: Identifier
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
