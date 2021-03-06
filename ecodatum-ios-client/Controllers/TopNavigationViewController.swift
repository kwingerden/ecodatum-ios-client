import Foundation
import UIKit

class TopNavigationViewController: BaseViewController {
  
  @IBOutlet weak var fullNameAndEmailLabel: UILabel!
  
  @IBOutlet weak var organizationNameLabel: UILabel!
  
  @IBOutlet weak var accountButton: UIButton!
  
  @IBOutlet weak var homeButton: UIButton!
  
  @IBOutlet weak var helpButton: UIButton!
  
  @IBOutlet weak var bodyView: UIView!
  
  private var topNavigationController: UINavigationController!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let authenticatedUser = viewControllerManager.authenticatedUser!
    let organization = viewControllerManager.organization!
    
    let fullName = authenticatedUser.fullName
    let email = authenticatedUser.email
    fullNameAndEmailLabel.text = "\(fullName) (\(email))"
    organizationNameLabel.text = organization.name
  
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    if let topNavigationController = segue.destination as? TopNavigationChoiceNavigationController {
      self.topNavigationController = topNavigationController
    }
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
    
    case accountButton:
      viewControllerManager.performSegue(to: .account)
      
    case helpButton:
      break
    
    case homeButton:
      topNavigationController.popToRootViewController(animated: true)
    
    default:
      LOG.error("Unrecognized button: \(sender)")
    
    }
    
  }
}
