import Foundation
import Hydra

class LoginService {
  
  let networkManager: NetworkManager
  
  let databaseManager: DatabaseManager
  
  let invalidationToken: InvalidationToken?
  
  init(networkManager: NetworkManager,
       databaseManager: DatabaseManager,
       invalidationToken: InvalidationToken? = nil) {
    self.networkManager = networkManager
    self.databaseManager = databaseManager
    self.invalidationToken = invalidationToken
  }
  
}

extension LoginService: Service {
  
  func run(_ loginRequest: LoginRequest) -> Promise<LoginResponse> {
    
    return async(
      in: .userInitiated,
      token: invalidationToken) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let userToken = try await(
          in: .userInitiated,
          self.networkManager.basicAuthUserCall(
            email: loginRequest.email,
            password: loginRequest.password))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let newUserToken = try await(
          in: .userInitiated,
          self.databaseManager.newUserToken(
            userId: userToken.userId,
            token: userToken.token))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let loginResponse = LoginResponse(
          userId: newUserToken.userId,
          token: newUserToken.token)
        
        return loginResponse
        
    }
    
  }
  
}

