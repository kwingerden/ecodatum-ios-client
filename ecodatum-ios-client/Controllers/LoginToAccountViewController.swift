import Foundation
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
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    viewControllerManager.login(
      email: email,
      password: password,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation)
    
  }
  
}
