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
  
  func login(_ request: LoginRequest) -> Promise<LoginResponse> {
    return LoginService(
      networkManager: networkManager,
      databaseManager: databaseManager,
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
  func createNewAccount(_ request: CreateNewAccountRequest) -> Promise<CreateNewAccountResponse> {
    return CreateNewAccountService(
      networkManager: networkManager,
      databaseManager: databaseManager,
      invalidationToken: InvalidationToken())
      .run(request)
  }
  
}
