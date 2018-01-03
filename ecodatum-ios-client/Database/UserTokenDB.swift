import Foundation
import GRDB

class UserTokenDB {
  
  var id: Int64
  var userId: Int
  var token: String
    
  init(id: Int64, userId: Int, token: String) {
    self.id = id
    self.userId = userId
    self.token = token
  }
  
}

extension UserTokenDB: Persistable {
  
  static let databaseTableName = "UserToken"
  
  enum Columns {
    static let id = Column("id")
    static let userId = Column("user_id")
    static let token = Column("token")
  }
  
  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.userId] = userId
    container[Columns.token] = token
  }

  func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
  
}

