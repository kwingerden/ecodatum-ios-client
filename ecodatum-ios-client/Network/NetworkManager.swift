import Foundation
import Hydra

class NetworkManager {
  
  let loginUrl: URL
  
  init(baseURL: URL) {
    self.loginUrl = baseURL.appendingPathComponent("login")
  }
  
  func basicAuthUserCall(email: String, password: String) -> Promise<UserTokenData> {
    return BasicAuthUserCall(
      email: email,
      password: password,
      url: loginUrl,
      invalidationToken: InvalidationToken()).run()
  }
  
}
