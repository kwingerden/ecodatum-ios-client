import Foundation
import Hydra

extension PromiseStatus {
  
  func checkCancelled(_ error: Error) throws {
    if isCancelled {
      cancel()
      throw error
    }
  }
  
}
