import Foundation
import Hydra

protocol DatabaseOperation {
  
  associatedtype DatabaseData
  func run(db: DatabaseManager) -> Promise<DatabaseData>
  
}
