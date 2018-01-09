import Foundation
import Hydra

class InsertUserTokenOperation {
  
  let userToken: UserTokenRecord
  
  init(userToken: UserTokenRecord) {
    self.userToken = userToken
  }
  
}

extension InsertUserTokenOperation: DatabaseOperation {
  
  func run(db: DatabaseManager) -> Promise<UserTokenRecord> {
    return Promise<UserTokenRecord>(in: .userInitiated) {
      resolve, reject, status in
      
      resolve(self.userToken)
    }
    
  }
  
}
