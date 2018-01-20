import Foundation
import UIKit

class AccountViewController: BaseViewController {
  
  var performSegueFrom: BaseViewController?
  
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    logoutButton.roundedButton()
    
  }
  
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    dismiss(animated: false, completion: nil)
    
    switch sender {
      
    case logoutButton:
      vcm?.logout()
      guard let performSegueFrom = performSegueFrom else {
        LOG.error("performSegueFrom not set")
        return
      }
      vcm?.performSegue(from: performSegueFrom, to: .main)
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
}



