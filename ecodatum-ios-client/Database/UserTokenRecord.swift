import Foundation
import GRDB

class UserTokenRecord: Record {
  
  override class var databaseTableName: String {
    return "UserToken"
  }
  
  enum Columns {
    static let id = Column("id")
    static let userId = Column("user_id")
    static let token = Column("token")
  }
  
  var id: Int64?
  var userId: Int
  var token: String
  
  init(id: Int64? = nil, userId: Int, token: String) {
    self.id = id
    self.userId = userId
    self.token = token
    super.init()
  }
  
  required init(row: Row) {
    id = row[Columns.id]
    userId = row[Columns.userId]
    token = row[Columns.token]
    super.init(row: row)
  }
  
  override func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.userId] = userId
    container[Columns.token] = token
  }
  
  override func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
  
  static func createTable(_ db: GRDB.Database) throws {
    try db.create(
      table: databaseTableName,
      temporary: false,
      ifNotExists: true) {
        table in
        table.column(UserTokenRecord.Columns.id.name, .integer).primaryKey()
        table.column(UserTokenRecord.Columns.userId.name, .integer).notNull()
        table.column(UserTokenRecord.Columns.token.name, .text).notNull()
    }
  }
  
}

extension UserTokenRecord: Equatable {
  
  static func ==(lhs: UserTokenRecord, rhs: UserTokenRecord) -> Bool {
    return lhs.id == rhs.id
  }
  
}
