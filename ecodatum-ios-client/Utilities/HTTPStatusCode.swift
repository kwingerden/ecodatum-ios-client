import Foundation

enum HTTPStatusCode: Int {
  
  case OK = 200
  
  func isInformational(statusCode: Int) -> Bool {
    return 100 ... 199 ~= statusCode
  }
  
  func isSuccess(statusCode: Int) -> Bool {
    return 200 ... 299 ~= statusCode
  }
  
  func isRedirection(statusCode: Int) -> Bool {
    return 300 ... 399 ~= statusCode
  }
  
  func isClientError(statusCode: Int) -> Bool {
    return 400 ... 499 ~= statusCode
  }
  
  func isServerError(statusCode: Int) -> Bool {
    return 500 ... 599 ~= statusCode
  }
  
}
