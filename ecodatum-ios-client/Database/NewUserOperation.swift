import Foundation
import Hydra

class NewUserOperation {
  
  let userId: Int
  
  let fullName: String
  
  let email: String
  
  init(userId: Int,
       fullName: String,
       email: String) {
    self.userId = userId
    self.fullName = fullName
    self.email = email
  }
  
}

extension NewUserOperation: DatabaseOperation {
  
  func run(_ databaseManager: DatabaseManager) -> Promise<UserRecord> {
    
    return Promise<UserRecord>(in: .userInitiated) {
      resolve, reject, status in
      
      let user = UserRecord(
        userId: self.userId,
        fullName: self.fullName,
        email: self.email)
      try databaseManager.write {
        db in
        try user.insert(db)
        return .commit
      }
      
      if user.id == nil {
        reject(DatabaseError.primaryKeyIdNotAssigned)
      } else {
        resolve(user)
      }
      
    }
    
  }
  
}

