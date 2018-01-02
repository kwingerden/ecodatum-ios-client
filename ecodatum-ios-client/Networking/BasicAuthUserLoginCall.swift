import Alamofire
import AlamofireSwiftyJSON
import Foundation

class BasicAuthUserLoginCall {
  
  let email: String
  
  let password: String
  
  let url: URL
  
  let responseHandler: (UserToken?, Error?) -> Void
  
  struct UserToken: Decodable {
    let id: Int
    let token: String
    let userId: Int
  }
  
  init(email: String,
       password: String,
       responseHandler: @escaping (UserToken?, Error?) -> Void) {
    self.email = email
    self.password = password
    self.url = ECODATUM_BASE_V1_API_URL.appendingPathComponent("login")
    self.responseHandler = responseHandler
  }
  
  func run() {
    
    guard let headers = Request.ecodatumHeaders(email: email, password: password) else {
      responseHandler(nil, OperationError.authorizationHeader)
      return
    }
    
    let request = Alamofire.request(
      url,
      method: .post,
      encoding: JSONEncoding.default,
      headers: headers)
      .validate(statusCode: [200])
      .responseData(queue: DispatchQueue.global(qos: .userInitiated)) {
        
        response in
        
        if let error = response.error {
          self.responseHandler(nil, error)
        } else if let data = response.data {
          do {
            let userToken = try JSONDecoder().decode(UserToken.self, from: data)
            self.responseHandler(userToken, nil)
          } catch let error {
            self.responseHandler(nil, error)
          }
        }
        
    }
    LOG.debug(request.debugDescription)
    
  }
  
}
