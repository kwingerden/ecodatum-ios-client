import Foundation
import UIKit

extension UITextView {
  
  func roundedTextView() {
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = 8
  }
  
}
