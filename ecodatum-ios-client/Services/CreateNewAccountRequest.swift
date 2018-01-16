import Foundation

struct CreateNewAccountRequest: ServiceRequest {
  
  let organizationCode: String
  let fullName: String
  let email: String
  let password: String
  
}
