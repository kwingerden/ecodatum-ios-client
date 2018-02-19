import Foundation
import UIKit

class AccountViewController: BaseViewController {
  
  @IBOutlet weak var changeOrganizationsButton: UIButton!
  
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    changeOrganizationsButton.rounded()
    logoutButton.rounded()
    
  }
  
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    dismiss(animated: false, completion: nil)
    
    guard let sourceViewController = viewControllerManager.storyboardSegue?.source else {
      LOG.error("Failed to obtain segue source view controller.")
      return
    }
    
    switch sender {
      
    case changeOrganizationsButton:
      sourceViewController.dismiss(animated: true, completion: nil)
      
    case logoutButton:
      viewControllerManager.logout(sourceViewController)
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
}



