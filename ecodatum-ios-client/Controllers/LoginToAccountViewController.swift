import Hydra
import SVProgressHUD
import SwiftValidator
import UIKit

class LoginToAccountViewController: BaseViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var loginButton: UIButton!
  
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
    
    preAsyncUIOperation()
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    login(email: email, password: password)
      .then(in: .userInteractive, getUserOrganizations)
      .then(in: .main, handleOrganizationChoice)
      .catch(in: .main) {
        error in
        if self.isUnauthorizedError(error) {
          SVProgressHUD.defaultShowError("Invalid username and/or password")
        } else {
          self.handleError(error)
        }
      }
      .always(in: .main, body: postAsyncUIOperation)
    
  }
  
}
