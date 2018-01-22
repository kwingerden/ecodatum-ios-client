import Foundation
import SwiftValidator

class DoubleRule: Rule {
  
  let message: String
  
  init(_ message: String = "Invalid value") {
    self.message = message
  }
  
  func validate(_ value: String) -> Bool {
    return value.toDouble() != nil
  }
  
  func errorMessage() -> String {
    return message
  }
  
}
