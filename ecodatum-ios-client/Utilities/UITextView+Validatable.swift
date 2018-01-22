import Foundation
import SwiftValidator
import UIKit

extension UITextView: Validatable {
  
  public var validationText: String {
    return text ?? ""
  }
  
}
