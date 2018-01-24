import Foundation
import UIKit

class WelcomeViewController: BaseViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var newAccountButton: UIButton!

  override func viewDidLoad() {
    
    super.viewDidLoad()
        
    LOG.debug("WelcomeViewController.viewDidLoad")
    
    loginButton.roundedButton()
    newAccountButton.roundedButton()
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case loginButton:
      performSegue(from: self, to: .loginToAccount)
      
    case newAccountButton:
      performSegue(from: self, to: .createNewAccount)
      
    default:
      LOG.warning("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


