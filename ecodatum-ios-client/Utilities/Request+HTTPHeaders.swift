import Alamofire
import Foundation

extension Request {
  
  static func defaultHeaders() -> HTTPHeaders? {
    return [
      "Accept":  "application/json; charset=utf-8"
    ]
  }
  
  static func basicAuthHeaders(
    email: String,
    password: String) -> HTTPHeaders? {
    
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
  
  static func bearerTokenAuthHeaders(_ bearerToken: String) -> HTTPHeaders? {
    return [
      "Authorization": "Bearer \(bearerToken)",
      "Accept":  "application/json; charset=utf-8"
    ]
  }
  
}

