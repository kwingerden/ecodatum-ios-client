import Foundation

enum ServiceError: Error {
  
  case authentication
  case base64Encoding
  case reponseDecoding(String)
  case serviceCancelled
  
}

