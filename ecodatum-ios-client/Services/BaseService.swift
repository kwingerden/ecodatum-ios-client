import Foundation
import Hydra

class BaseService {
  
  let networkManager: NetworkManager
  
  let databaseManager: DatabaseManager
  
  let invalidationToken: InvalidationToken?
  
  init(networkManager: NetworkManager,
       databaseManager: DatabaseManager,
       invalidationToken: InvalidationToken? = nil) {
    self.networkManager = networkManager
    self.databaseManager = databaseManager
    self.invalidationToken = invalidationToken
  }
  
  func assertNotNil<T>(_ t: T?) throws -> T {
    if t == nil {
      throw ServiceError.invalidIdentifier
    }
    return t!
  }
  
}

