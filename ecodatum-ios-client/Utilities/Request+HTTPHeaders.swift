import Alamofire
import Foundation

extension Request {

  static func ecodatumHeaders(email: String, password: String) -> HTTPHeaders? {
    
    guard let authorizationHeader = Request.authorizationHeader(
      user: email,
      password: password) else {
        return nil
    }
    
    return [
      authorizationHeader.key: authorizationHeader.value,
      "Accept":  "application/json; charset=utf-8"
    ]
    
  }
  
}

