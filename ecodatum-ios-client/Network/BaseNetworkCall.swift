import Alamofire
import Foundation
import Hydra

class BaseNetworkCall {
  
  let url: URL
  
  let invalidationToken: InvalidationToken?
  
  init(url: URL,
       invalidationToken: InvalidationToken? = nil) {
    self.url = url
    self.invalidationToken = invalidationToken
  }
  
  func validate(url: URL) throws -> (String, String, Int) {
    guard let scheme = url.scheme,
      let host = url.host,
      let port = url.port else {
        throw NetworkError.invalidURL(url: url.absoluteString)
    }
    return (scheme, host, port)
  }
  
  
}
