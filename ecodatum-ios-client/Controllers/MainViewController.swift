import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var newAccountButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
  
    log.debug("MainViewController.viewDidLoad")
    
    loginButton.roundedButton()
    newAccountButton.roundedButton()
  
  }

}

