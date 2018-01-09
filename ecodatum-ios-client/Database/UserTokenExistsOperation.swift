import Foundation
import Hydra

class UserTokenExistsOperation {
  
  let userToken: UserTokenRecord
  
  init(userToken: UserTokenRecord) {
    self.userToken = userToken
  }
  
}

extension UserTokenExistsOperation: DatabaseOperation {
  
  func run(_ databaseManager: DatabaseManager) -> Promise<Bool> {
    
    return Promise<Bool>(in: .userInitiated) {
      resolve, reject, status in
      
      let result = try databaseManager.read {
        db in
        return try self.userToken.exists(db)
      }
      
      resolve(result)
      
    }
    
  }
  
}

