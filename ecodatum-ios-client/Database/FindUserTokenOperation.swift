import Foundation
import Hydra

class FindUserTokenOperation {
  
  let id: DatabaseManager.DB_ID_TYPE
  
  init(id: DatabaseManager.DB_ID_TYPE) {
    self.id = id
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


