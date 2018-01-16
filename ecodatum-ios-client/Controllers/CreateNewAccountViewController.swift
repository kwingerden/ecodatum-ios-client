import UIKit
import SwiftValidator

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
  
  private let validator = Validator()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    createNewAccountButton.roundedButton()
    
    func successStyleTransformer(rule: ValidationRule) {
      
      let textField = rule.field as! UITextField
      textField.layer.borderColor = UIColor.green.cgColor
      textField.layer.borderWidth = 0.5
      rule.errorLabel?.text = nil
      rule.errorLabel?.isHidden = true
      
    }
    
    func errorStyleTransformer(error: ValidationError) {
      
      let textField = error.field as! UITextField
      textField.layer.borderColor = UIColor.red.cgColor
      textField.layer.borderWidth = 1.0
      error.errorLabel?.text = error.errorMessage
      error.errorLabel?.isHidden = false
      
    }
    
    validator.styleTransformers(
      success: successStyleTransformer,
      error: errorStyleTransformer)
    
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
    validator.validate(self)
  }
  
}

extension CreateNewAccountViewController: ValidationDelegate {
  
  func validationSuccessful() {
    
    func updateUI(isEnabled: Bool = true,
                  showActivityIndicator: Bool = false,
                  error: Error? = nil) {
      
      organizationCodeTextField.isEnabled = isEnabled
      fullNameTextField.isEnabled = isEnabled
      emailAddressTextField.isEnabled = isEnabled
      passwordTextField.isEnabled = isEnabled
      createNewAccountButton.isEnabled = isEnabled
      if showActivityIndicator {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
      
      if error != nil {
        
        let alert = UIAlertController(
          title: "Account Creation Failure",
          message: "Account already exists or failed to be created.",
          preferredStyle: .alert)
        alert.addAction(
          UIAlertAction(
            title: "OK",
            style: .default))
        present(alert,
                animated: true,
                completion: nil)
        
      }
      
    }
    
    updateUI(isEnabled: false, showActivityIndicator: true)
    
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
        createNewAccountReponse in
        LOG.debug(createNewAccountReponse)
        // TODO: segue to the next page
      }.catch(in: .main) {
        error in
        LOG.error(error)
        updateUI(error: error)
    }
    
  }
  
  func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    // validation failures are handled with validator styleTransformers above
  }
  
}



