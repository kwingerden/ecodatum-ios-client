import Foundation
import Hydra

class ServiceManager {
  
  let databaseManager: DatabaseManager
  
  let networkManager: NetworkManager
  
  init(databaseManager: DatabaseManager,
       networkManager: NetworkManager) {
    self.databaseManager = databaseManager
    self.networkManager = networkManager
  }
  
  func call(_ request: BasicAuthUserRequest) -> Promise<BasicAuthUserResponse> {
  
    return async(
      in: .userInitiated,
      token: InvalidationToken()) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let response = try await(
          in: .userInitiated,
          self.networkManager.call(request))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let _ = try await(
          in: .userInitiated,
          self.databaseManager.newUserToken(
            userId: response.userId,
            token: response.token))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return response
        
    }
    
 }
  
  func call(_ request: CreateNewOrganizationUserRequest) -> Promise<CreateNewOrganizationUserResponse> {
    
    return async(
      in: .userInitiated,
      token: InvalidationToken()) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let response = try await(
          in: .userInitiated,
          self.networkManager.call(request))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let _ = try await(
          in: .userInitiated,
          self.databaseManager.newUser(
            userId: response.id,
            fullName: response.fullName,
            email: response.email))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return response
        
    }
    
  }
  
  func call(_ request: GetOrganizationsByUserIdRequest) -> Promise<[GetOrganizationsByUserIdResponse]> {
    
    return async(
      in: .userInitiated,
      token: InvalidationToken()) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let response = try await(
          in: .userInitiated,
          self.networkManager.call(request))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return response
        
    }
    
  }
  
  func call(_ request: GetUserByIdRequest) -> Promise<GetUserByIdResponse> {
    
    return async(
      in: .userInitiated,
      token: InvalidationToken()) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let response = try await(
          in: .userInitiated,
          self.networkManager.call(request))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return response
        
    }
    
  }
  
}
