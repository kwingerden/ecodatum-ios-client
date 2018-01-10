import Foundation
import Hydra

class FindUserTokenOperation {
  
  let id: Int
  
  init(byId: Int) {
    self.id = byId
  }
  
}

extension FindUserTokenOperation: DatabaseOperation {
  
  func run(_ databaseManager: DatabaseManager) -> Promise<UserTokenRecord?> {
    
    return Promise<UserTokenRecord?>(in: .userInitiated) {
      resolve, reject, status in
      
      let result = try databaseManager.read {
        db in
        return try UserTokenRecord.fetchOne(db, key: self.id)
      }
      
      resolve(result)
      
    }
    
  }
  
}


