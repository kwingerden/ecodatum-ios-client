import Foundation

enum NetworkingError: Error {
  
  case authorizationHeaderEncoding
  case credentialStorage
  case invalidURL(url: URL)

}
