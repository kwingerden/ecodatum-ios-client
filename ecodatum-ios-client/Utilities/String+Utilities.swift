import Foundation

extension String {
  
  func toDouble() -> Double? {
    if let value = Double(self) {
      return value
    } else {
      return nil
    }
  }
  
  func replaceNewlines() -> String {
    return self.replacingOccurrences(of: "\n", with: " ")
  }
  
}
