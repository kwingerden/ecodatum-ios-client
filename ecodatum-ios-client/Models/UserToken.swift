import Foundation
import RealmSwift

class UserToken: Object {
  
  @objc dynamic var userId: Int = 0
  
  @objc dynamic var token: String = ""
  
  override static func primaryKey() -> String? {
    return "userId"
  }
  
}

extension UserToken {

  static func make(userId: Int, token: String) -> UserToken {
    let userToken = UserToken()
    userToken.userId = userId
    userToken.token = token
    return userToken
  }
  
}

