import Foundation
import UIKit

class AccountViewController: BaseViewController, SegueSourceViewControllerHolder {
  
  var segueSourceViewController: UIViewController!
  
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    logoutButton.rounded()
    
  }
  
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    dismiss(animated: false, completion: nil)
    
    switch sender {
      
    case logoutButton:
      viewControllerManager.logout(segueSourceViewController)
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
}



