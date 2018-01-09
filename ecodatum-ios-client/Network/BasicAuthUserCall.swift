import Alamofire
import Foundation
import Hydra

class BasicAuthUserCall {
  
  let email: String
  
  let password: String
  
  let invalidationToken: InvalidationToken?
  
  let url: URL
  
  init(email: String,
       password: String,
       invalidationToken: InvalidationToken? = nil) {
    self.email = email
    self.password = password
    self.invalidationToken = invalidationToken
    self.url = ECODATUM_BASE_V1_API_URL.appendingPathComponent("login")
  }
  
}

extension BasicAuthUserCall: NetworkCall {
  
  func run() -> Promise<UserTokenData> {
    
    guard let headers = Request.ecodatumHeaders(email: email, password: password) else {
      return Promise(rejected: NetworkError.authorizationHeaderEncoding)
    }
    
    guard let scheme = url.scheme,
      let host = url.host,
      let port = url.port else {
        return Promise(rejected: NetworkError.invalidURL(url: self.url))
    }
    
    let credential = URLCredential(
      user: email,
      password: password,
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
    
    return Promise<UserTokenData>(
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
              let userToken = try JSONDecoder().decode(UserTokenData.self, from: data)
              resolve(userToken)
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
