import UIKit

extension UIView {
  
  func rounded() {
    layer.cornerRadius = 8
    clipsToBounds = true
  }
  
  func darkBordered() {
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.black.cgColor
  }
  
  func lightBordered() {
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
  }

  func errorBordered() {
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.red.cgColor
  }
  
  func roundedAndLightBordered() {
    rounded()
    lightBordered()
  }
  
  func roundedAndDarkBordered() {
    rounded()
    darkBordered()
  }

  func roundedAndErrorBordered() {
    rounded()
    errorBordered()
  }
  
}
