import Foundation
import SwiftValidator
import UIKit

class CreateNewAccountViewController: BaseContentViewScrollable {
  
  @IBOutlet weak var organizationCodeTextField: UITextField!
  
  @IBOutlet weak var organizationCodeErrorLabel: UILabel!
  
  @IBOutlet weak var fullNameTextField: UITextField!
  
  @IBOutlet weak var fullNameErrorLabel: UILabel!
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var createNewAccountButton: UIButton!
  
  @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createNewAccountButton.rounded()
    
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
    
    let organizationCode = organizationCodeTextField.text!
    let fullName = fullNameTextField.text!
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    viewControllerManager.createNewAccount(
      organizationCode: organizationCode.uppercased(),
      fullName: fullName,
      email: email.lowercased(),
      password: password,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation)
    
  }
  
}



