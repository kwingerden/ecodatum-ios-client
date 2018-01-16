import Foundation

struct CreateNewUserRequest: NetworkRequest {
  
  let organizationCode: String
  let fullName: String
  let email: String
  let password: String
  
}
