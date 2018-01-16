import Foundation
import GRDB

class UserRecord: Record {
  
  override class var databaseTableName: String {
    return "User"
  }
  
  enum Columns {
    static let id = Column("id")
    static let userId = Column("user_id")
    static let fullName = Column("full_name")
    static let email = Column("email")
  }
  
  var id: Int?
  var userId: Int?
  var fullName: String
  var email: String
  
  init(id: Int? = nil,
       userId: Int,
       fullName: String,
       email: String) {
    self.id = id
    self.userId = userId
    self.fullName = fullName
    self.email = email
    super.init()
  }
  
  required init(row: Row) {
    id = row[Columns.id]
    userId = row[Columns.userId]
    fullName = row[Columns.fullName]
    email = row[Columns.email]
    super.init(row: row)
  }
  
  override func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.userId] = userId
    container[Columns.fullName] = fullName
    container[Columns.email] = email
  }
  
  override func didInsert(with rowID: Int64,
                          for column: String?) {
    id = Int(rowID)
  }
  
  static func createTable(_ db: GRDB.Database) throws {
    try db.create(
      table: databaseTableName,
      temporary: false,
      ifNotExists: true) {
        table in
        table.column(UserRecord.Columns.id.name, .integer).primaryKey()
        table.column(UserRecord.Columns.userId.name, .integer).notNull()
        table.column(UserRecord.Columns.fullName.name, .text).notNull()
        table.column(UserRecord.Columns.email.name, .text).notNull()
    }
  }
  
}

extension UserRecord: Equatable {
  
  static func ==(lhs: UserRecord, rhs: UserRecord) -> Bool {
    return lhs.id == rhs.id
  }
  
}

