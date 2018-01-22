import SVProgressHUD
import SwiftValidator
import UIKit

class LoginToAccountViewController: BaseViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
        
    loginButton.roundedButton()
    
    validator.registerField(
      emailAddressTextField,
      errorLabel: emailAddressErrorLabel,
      rules: [RequiredRule(), EmailRule()])
    validator.registerField(
      passwordTextField,
      errorLabel: passwordErrorLabel,
      rules: [RequiredRule()])
    
  }
  
  @IBAction func backButtonTouchUpInside() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func loginButtonTouchUpInside() {
    validator.defaultValidate(validationSuccessful)
  }
  
  private func validationSuccessful() {
    
    view.isUserInteractionEnabled = false
    activityIndicator.startAnimating()
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    vcm?.login(
      email: email,
      password: password)
      .then(in: .main) {
        loginResponse in
        LOG.debug(loginResponse)
        self.vcm?.performSegue(
          from: self,
          to: .topNavigation,
          context: loginResponse)
      }.catch(in: .main) {
        error in
        LOG.error(error)
        SVProgressHUD.defaultShowError(
          "Unrecognized email address and/or password.")
      }.always(in: .main) {
        self.view.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
    }
    
  }
  
}
