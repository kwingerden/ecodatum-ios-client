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
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
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
    
    view.isUserInteractionEnabled = false
    activityIndicator.startAnimating()
    
    let organizationCode = organizationCodeTextField.text!
    let fullName = fullNameTextField.text!
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    
    vcm?.createNewAccount(
      organizationCode: organizationCode.uppercased(),
      fullName: fullName,
      email: email.lowercased(),
      password: password)
      .then(in: .main) {
        createNewAccountResponse in
        LOG.debug(createNewAccountResponse)
        self.vcm?.performSegue(
          from: self,
          to: .topNavigation,
          context: createNewAccountResponse)
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



