import Alamofire
import Foundation
import Hydra

class CreateNewUserCall: BaseNetworkCall {
  
}

extension CreateNewUserCall: NetworkCall {
  
  func run(_ request: CreateNewUserRequest) throws -> Promise<CreateNewUserResponse> {
    
    let parameters = try JSONSerialization.jsonObject(
      with: try JSONEncoder().encode(request),
      options: [])
      as? [String: Any]
    
    let request = Alamofire.request(
      url,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: Request.defaultHeaders())
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<CreateNewUserResponse>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(CreateNewUserResponse.self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

