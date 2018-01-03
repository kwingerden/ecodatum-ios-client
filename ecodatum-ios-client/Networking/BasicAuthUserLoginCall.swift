import Alamofire
import AlamofireSwiftyJSON
import Foundation

class BasicAuthUserLoginCall {
  
  let email: String
  
  let password: String
  
  let url: URL
  
  let responseHandler: HTTPResponseHandler<UserTokenJSON>
  
  init(email: String,
       password: String,
       responseHandler: @escaping HTTPResponseHandler<UserTokenJSON>) {
    self.email = email
    self.password = password
    self.url = ECODATUM_BASE_V1_API_URL.appendingPathComponent("login")
    self.responseHandler = responseHandler
  }
  
  func run()  {
    
    guard let headers = Request.ecodatumHeaders(email: email, password: password) else {
      responseHandler(.error(NetworkingError.authorizationHeaderEncoding))
      return
    }
    
    guard let scheme = url.scheme,
      let host = url.host,
      let port = url.port else {
        responseHandler(.error(NetworkingError.invalidURL(url: url)))
      return
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
    
    request.validate(statusCode: [200])
      .responseData(queue: DispatchQueue.global(qos: .userInitiated)) {
        
        response in
        
        if let error = response.error {
          self.responseHandler(.error(error))
        } else if let data = response.data {
          do {
            let userToken = try JSONDecoder().decode(UserTokenJSON.self, from: data)
            self.responseHandler(.success(userToken))
          } catch let error {
            self.responseHandler(.error(error))
          }
        }
        
    }
    
  }
  
}
