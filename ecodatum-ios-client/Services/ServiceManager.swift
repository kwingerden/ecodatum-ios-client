import Foundation
import Hydra

class ServiceManager {
  
  let databaseManager: DatabaseManager
  
  let networkManager: NetworkManager
  
  init(databaseManager: DatabaseManager,
       networkManager: NetworkManager) {
    self.databaseManager = databaseManager
    self.networkManager = networkManager
  }
  
  func login(email: String, password: String) -> Promise<LoginResponse> {
    let loginRequest = LoginRequest(email: email, password: password)
    return LoginService(
      networkManager: networkManager,
      databaseManager: databaseManager,
      invalidationToken: InvalidationToken())
      .run(loginRequest)
  }
  
}
