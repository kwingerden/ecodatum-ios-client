import UIKit

class LoginToMyAccountController: UIViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
  }
  
  @IBAction func loginButtonTouchUpInside() {
    
    activityIndicator.startAnimating()
    
  }
  
}


