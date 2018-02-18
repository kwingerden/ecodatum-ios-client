import Foundation
import UIKit

class FormSheetCancelButton: UIButton {
  
  private var viewController: UIViewController? = nil
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func initialize(_ viewController: UIViewController) {
    
    self.viewController = viewController
    
    isHidden = false
    addTarget(
      self,
      action: #selector(self.buttonClicked),
      for: .touchUpInside)
    
  }
  
  @objc private func buttonClicked() {
    
    if let viewController = viewController {
      viewController.dismiss(animated: true, completion: nil)
    }
  
  }
  
}
