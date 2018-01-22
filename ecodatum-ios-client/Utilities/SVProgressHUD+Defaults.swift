import Foundation
import SVProgressHUD
import UIKit

extension SVProgressHUD {
  
  static func defaultShowError(_ status: String) {
    SVProgressHUD.setForegroundColor(OLIVE_GREEN)
    SVProgressHUD.setBackgroundColor(DARK_GREEN.withAlphaComponent(0.85))
    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 18))
    SVProgressHUD.setMinimumSize(CGSize(width: 200, height: 200))
    SVProgressHUD.setBorderColor(UIColor.black)
    SVProgressHUD.setBorderWidth(1)
    SVProgressHUD.setHapticsEnabled(true)
    SVProgressHUD.showError(withStatus: status)
  }
  
}
