import Foundation
import UIKit

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

  func base64Encode() -> Base64Encoded? {
    return data(using: .utf8)?.base64EncodedString()
  }
  
  func base64Decode() -> Data? {
    return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
  }
  
}

extension NSAttributedString {

  static func base64Decode(_ base64Encoded: Base64Encoded) throws -> NSAttributedString {
    let decoded = String(data: base64Encoded.base64Decode()!, encoding: .utf8)!
    let data = decoded.data(using: .utf8)!
    return try NSAttributedString(
      data: data,
      options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ],
      documentAttributes: nil)
  }

  func base64Encode() throws -> Base64Encoded? {
    let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [
      .documentType : NSAttributedString.DocumentType.html
    ]
    let htmlData = try data(
      from: NSRange(location: 0, length: length),
      documentAttributes: documentAttributes)
    return htmlData.base64EncodedString()
  }

}
