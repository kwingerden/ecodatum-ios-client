import SVProgressHUD
import SwiftValidator
import UIKit

class CreateNewAccountViewController: BaseViewController {
  
  @IBOutlet weak var organizationCodeTextField: UITextField!
  
  @IBOutlet weak var organizationCodeErrorLabel: UILabel!
  
  @IBOutlet weak var fullNameTextField: UITextField!
  
  @IBOutlet weak var fullNameErrorLabel: UILabel!
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var createNewAccountButton: UIButton!
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createNewAccountButton.roundedButton()
    
    validator.registerField(
      organizationCodeTextField,
      errorLabel: organizationCodeErrorLabel,
      rules: [RequiredRule()])
    validator.registerField(
      fullNameTextField,
      errorLabel: fullNameErrorLabel,
      rules: [RequiredRule(), FullNameRule()])
    validator.registerField(
      emailAddressTextField,
      errorLabel: emailAddressErrorLabel,
      rules: [RequiredRule(), EmailRule()])
    validator.registerField(
      passwordTextField,
      errorLabel: passwordErrorLabel,
      rules: [RequiredRule(), PasswordRule()])
    
  }
  
  @IBAction func backButtonTouchUpInside() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func createNewAccountButtonTouchUpInside() {
    validator.defaultValidate(validationSuccessful)
  }
  
  private func validationSuccessful() {
    
    preAsyncUIOperation()
    
    let organizationCode = organizationCodeTextField.text!
    let fullName = fullNameTextField.text!
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    createNewAccount(
      organizationCode: organizationCode.uppercased(),
      fullName: fullName,
      email: email.lowercased(),
      password: password)
      .then(in: .userInteractive, getUserOrganizations)
      .then(in: .main, handleOrganizationChoice)
      .catch(in: .main, handleError)
      .always(in: .main, body: postAsyncUIOperation)
    
  }
  
}



