import Alamofire
import Foundation
import Hydra

class BasicAuthUserCall: BaseNetworkCall {

}

extension BasicAuthUserCall: NetworkCall {
  
  func run(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    
    guard let headers = Request.basicAuthHeaders(
      email: request.email,
      password: request.password) else {
      throw NetworkError.authorizationHeaderEncoding
    }
    
    guard let (scheme, host, port) = try? validate(url: url) else {
      throw NetworkError.invalidURL(url: self.url.absoluteString)
    }
    
    let credential = URLCredential(
      user: request.email,
      password: request.password,
      persistence: .forSession)
    let protectionSpace = URLProtectionSpace(
      host: host,
      port: port,
      protocol: scheme,
      realm: host,
      authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
    URLCredentialStorage.shared.setDefaultCredential(credential, for: protectionSpace)
    
    let request = Alamofire.request(
      url,
      method: .post,
      encoding: JSONEncoding.default,
      headers: headers)
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<BasicAuthUserResponse>(
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
              let response = try JSONDecoder().decode(BasicAuthUserResponse.self, from: data)
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
