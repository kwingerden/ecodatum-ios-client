import Foundation
import UIKit

class AccountViewController:
  BaseViewController, SegueViewControllerHolder {
  
  var segueViewController: BaseViewController!
  
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    logoutButton.roundedButton()
    
  }
  
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    dismiss(animated: false, completion: nil)
    
    switch sender {
      
    case logoutButton:
      logout()
      performSegue(from: segueViewController, to: .main)
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
}



