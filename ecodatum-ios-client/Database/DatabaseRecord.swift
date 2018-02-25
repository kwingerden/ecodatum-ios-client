import Foundation
import GRDB

class BaseDatabaseRecord: Record, Equatable {
  
  var id: Int?
  
  enum Columns {
    static let id = Column("id")
  }
  
  init(id: Int? = nil) {
    self.id = id
    super.init()
  }
  
  required init(row: Row) {
    id = row[Columns.id]
    super.init(row: row)
  }
  
  override func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
  }
  
  override func didInsert(with rowID: Int64,
                          for column: String?) {
    id = Int(rowID)
  }
  
  static func definePrimaryKey(_ table: TableDefinition) {
    table.column(BaseDatabaseRecord.Columns.id.name, .integer).primaryKey()
  }
  
  static func ==(lhs: BaseDatabaseRecord, rhs: BaseDatabaseRecord) -> Bool {
    return lhs.id == rhs.id
  }
  
}

class AuthenticatedUserRecord: BaseDatabaseRecord {
  
  override class var databaseTableName: String {
    return "AuthenticatedUser"
  }
  
  enum Columns {
    static let userId = Column("user_id")
    static let token = Column("token")
    static let fullName = Column("full_name")
    static let email = Column("email")
    static let isRootUser = Column("is_root_user")
  }

  var userId: String
  var token: String
  var fullName: String
  var email: String
  var isRootUser: Bool
  
  init(id: Int? = nil,
       userId: String,
       token: String,
       fullName: String,
       email: String,
       isRootUser: Bool) {
    self.userId = userId
    self.token = token
    self.fullName = fullName
    self.email = email
    self.isRootUser = isRootUser
    super.init(id: id)
  }
  
  required init(row: Row) {
    userId = row[Columns.userId]
    token = row[Columns.token]
    fullName = row[Columns.fullName]
    email = row[Columns.email]
    isRootUser = row[Columns.isRootUser]
    super.init(row: row)
  }
  
  override func encode(to container: inout PersistenceContainer) {
    super.encode(to: &container)
    container[Columns.userId] = userId
    container[Columns.token] = token
    container[Columns.fullName] = fullName
    container[Columns.email] = email
    container[Columns.isRootUser] = isRootUser
  }
  
  static func createTable(_ db: GRDB.Database) throws {
    try db.create(
      table: databaseTableName,
      temporary: false,
      ifNotExists: true) {
        table in
        definePrimaryKey(table)
        table.column(
          AuthenticatedUserRecord.Columns.userId.name, .text)
          .notNull()
        table.column(
          AuthenticatedUserRecord.Columns.token.name, .text)
          .notNull()
        table.column(
          AuthenticatedUserRecord.Columns.fullName.name, .text)
          .notNull()
        table.column(
          AuthenticatedUserRecord.Columns.email.name, .text)
          .notNull()
        table.column(
          AuthenticatedUserRecord.Columns.isRootUser.name, .boolean)
          .notNull()
    }
  }
  
}

