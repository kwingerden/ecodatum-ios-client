import Foundation
import GRDB

struct UserToken {
  
  var id: Int64
  var userId: Int
  var token: String
  
}

extension UserToken: MutablePersistable {
  
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

  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
  
}

