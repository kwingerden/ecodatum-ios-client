import Foundation

enum NetworkError: Error {
  
  case authorizationHeaderEncoding
  case credentialStorage
  case unexpectedResponse
  case invalidURL(url: String)

}
