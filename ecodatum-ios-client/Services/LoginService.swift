import Foundation
import Hydra

class LoginService: BaseService {
  
}

extension LoginService: Service {
  
  func run(_ request: LoginRequest) -> Promise<LoginResponse> {
    
    return async(
      in: .userInitiated,
      token: invalidationToken) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let basicAuthUserRequest = BasicAuthUserRequest(
          email: request.email.lowercased(),
          password: request.password)
        let basicAuthUserResponse = try await(
          in: .userInitiated,
          self.networkManager.basicAuthUserCall(basicAuthUserRequest))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let _ = try await(
          in: .userInitiated,
          self.databaseManager.newUserToken(
            userId: basicAuthUserResponse.userId,
            token: basicAuthUserResponse.token))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return LoginResponse(token: basicAuthUserResponse.token)
        
    }
    
  }
  
}

