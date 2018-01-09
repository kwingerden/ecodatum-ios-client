import Foundation
import Hydra

protocol DatabaseOperation {
  
  associatedtype DatabaseResult
  func run(_ databaseManager: DatabaseManager) -> Promise<DatabaseResult>
  
}
