import Foundation
import UIKit

class TopNavigationViewController: BaseViewController {
  
  @IBOutlet weak var emailAddressLabel: UILabel!
  
  @IBOutlet weak var organizationNameLabel: UILabel!
  
  @IBOutlet weak var accountButton: UIButton!
  
  @IBOutlet weak var homeButton: UIButton!
  
  @IBOutlet weak var helpButton: UIButton!
  
  @IBOutlet weak var bodyView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
    
    case accountButton:
      vcm?.performSegue(from: self, to: .account)
      
    case helpButton:
      break
    
    case homeButton:
      break
    
    default:
      LOG.error("Unrecognized button: \(sender)")
    
    }
    
  }
}
