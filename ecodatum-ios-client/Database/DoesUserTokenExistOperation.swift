import Foundation
import Hydra

class DoesUserTokenExistOperation {
  
  let id: Int
  
  init(byId: Int) {
    self.id = byId
  }
  
}

extension DoesUserTokenExistOperation: DatabaseOperation {
  
  func run(_ databaseManager: DatabaseManager) -> Promise<Bool> {
    
    return Promise<Bool>(in: .userInitiated) {
      resolve, reject, status in
      
      let result = try databaseManager.read {
        db in
        return try UserTokenRecord.fetchOne(db, key: self.id)
      }
      
      resolve(result != nil)
      
    }
    
  }
  
}


