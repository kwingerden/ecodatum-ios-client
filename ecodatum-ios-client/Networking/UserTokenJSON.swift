import Foundation

struct UserTokenJSON: Decodable, Encodable {
  
  let id: Int
  let token: String
  let userId: Int

}
