import Foundation
import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var newAccountButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    LOG.debug("MainViewController.viewDidLoad")
    
    loginButton.roundedButton()
    newAccountButton.roundedButton()
    
    if ControllerManager.shared == nil {
      do {
        ControllerManager.shared = try ControllerManager()
      } catch let error {
        LOG.error(error.localizedDescription)
        // TODO: add some UI warning to user
      }
    }
    
  }
  
}

