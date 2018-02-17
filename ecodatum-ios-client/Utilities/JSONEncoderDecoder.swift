import Foundation

extension JSONEncoder.DateEncodingStrategy {
  
  static let customISO8601 = custom {
    date, encoder throws in
  
    var container = encoder.singleValueContainer()
    try container.encode(Formatter.iso8601.string(from: date))
  
  }
  
}

extension JSONDecoder.DateDecodingStrategy {
  
  static let customISO8601 = custom {
    decoder throws -> Date in
  
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    
    if let date = Formatter.iso8601.date(from: string) {
      return date
    } else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Invalid date: \(string)")
    }
  
  }
  
}

