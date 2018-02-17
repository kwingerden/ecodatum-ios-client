import Foundation

extension Formatter {
  
  static let iso8601: ISO8601DateFormatter = {
    
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    return formatter
    
  }()
  
  static let basic: DateFormatter =  {
    
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    
    return formatter
    
  }()
  
}
