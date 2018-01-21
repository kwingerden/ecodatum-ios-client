import Foundation
import Hydra

class CreateNewAccountService: BaseService {
  
}

extension CreateNewAccountService: Service {
  
  func run(_ request: CreateNewAccountRequest) -> Promise<CreateNewAccountResponse> {
    
    return async(
      in: .userInitiated,
      token: invalidationToken) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let createNewUserRequest = CreateNewOrganizationUserRequest(
          organizationCode: request.organizationCode,
          fullName: request.fullName,
          email: request.email,
          password: request.password)
        let createNewUserResponse = try await(
          in: .userInitiated,
          self.networkManager.call(createNewUserRequest))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let _ = try await(
          in: .userInitiated,
          self.databaseManager.newUser(
            userId: createNewUserResponse.id,
            fullName: createNewUserResponse.fullName,
            email: createNewUserResponse.email))
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return CreateNewAccountResponse(userId: createNewUserResponse.id)
        
    }
    
  }
  
}


