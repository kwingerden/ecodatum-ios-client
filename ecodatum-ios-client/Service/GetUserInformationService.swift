import Foundation
import Hydra

class GetUserInformationService: BaseService {
  
}

extension GetUserInformationService: Service {
  
  func run(_ request: GetUserInformationRequest) -> Promise<GetUserInformationResponse> {
    
    return async(
      in: .userInitiated,
      token: invalidationToken) {
        
        status in
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        let getUserByIdRequest = GetUserByIdRequest(token: "", userId: request.userId)
        let getUserByIdResponse: GetUserByIdResponse = try await(
          in: .userInitiated,
          self.networkManager.call(getUserByIdRequest))
        
        try status.checkCancelled(ServiceError.serviceCancelled)
        
        return GetUserInformationResponse(fullName: getUserByIdResponse.fullName,
                                          email: getUserByIdResponse.email)
        
    }
    
  }
  
}



