import Foundation

enum ServiceError: Error {
  
  case authentication
  case base64Encoding
  case invalidIdentifier
  case reponseDecoding(String)
  case serviceCancelled
  
}

