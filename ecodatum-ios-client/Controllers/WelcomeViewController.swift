import Foundation
import UIKit

class WelcomeViewController: BaseContentViewScrollable {
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var newAccountButton: UIButton!
  
  @IBOutlet weak var versionLabel: UILabel!
  override func viewDidLoad() {
    
    super.viewDidLoad()
        
    LOG.debug("WelcomeViewController.viewDidLoad")
    
    loginButton.rounded()
    newAccountButton.rounded()
    
    versionLabel.text = BUILD_VERSION
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case loginButton:
      viewControllerManager.performSegue(to: .loginToAccount)
      
    case newAccountButton:
      viewControllerManager.performSegue(to: .createNewAccount)
      
    default:
      LOG.warning("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


