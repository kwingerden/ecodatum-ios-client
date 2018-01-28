import Foundation
import UIKit

class TopNavigationViewController: BaseViewController {
  
  @IBOutlet weak var fullNameAndEmailLabel: UILabel!
  
  @IBOutlet weak var organizationNameLabel: UILabel!
  
  @IBOutlet weak var accountButton: UIButton!
  
  @IBOutlet weak var homeButton: UIButton!
  
  @IBOutlet weak var helpButton: UIButton!
  
  @IBOutlet weak var bodyView: UIView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let authenticatedUser = viewControllerManager.authenticatedUser!
    let organization = viewControllerManager.organization!
    
    let fullName = authenticatedUser.fullName
    let email = authenticatedUser.email
    fullNameAndEmailLabel.text = "\(fullName) (\(email))"
    organizationNameLabel.text = organization.name
  
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
    
    case accountButton:
      viewControllerManager.performSegue(to: .account)
      
    case helpButton:
      break
    
    case homeButton:
      break
    
    default:
      LOG.error("Unrecognized button: \(sender)")
    
    }
    
  }
}
