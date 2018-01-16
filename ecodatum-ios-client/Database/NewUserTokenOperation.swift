import Foundation
import Hydra

class NewUserTokenOperation {
  
  let userId: Int
  
  let token: String
  
  init(userId: Int,
       token: String) {
    self.userId = userId
    self.token = token
  }
  
}

extension NewUserTokenOperation: DatabaseOperation {
  
  func run(_ databaseManager: DatabaseManager) -> Promise<UserTokenRecord> {
    
    return Promise<UserTokenRecord>(in: .userInitiated) {
      resolve, reject, status in
      
      let userToken = UserTokenRecord(userId: self.userId, token: self.token)
      try databaseManager.write {
        db in
        try userToken.insert(db)
        return .commit
      }
      
      if userToken.id == nil {
        reject(DatabaseError.primaryKeyIdNotAssigned)
      } else {
        resolve(userToken)
      }
      
    }
    
  }
  
}
