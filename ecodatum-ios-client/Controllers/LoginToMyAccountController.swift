import UIKit
import SwiftValidator

class LoginToMyAccountController: UIViewController, ValidationDelegate {

  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private let validator = Validator()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loginButton.roundedButton()
    
    validator.registerField(emailAddressTextField, rules: [RequiredRule(), EmailRule()])
    validator.registerField(passwordTextField, rules: [RequiredRule(), PasswordRule()])
    
  }
  
  @IBAction func loginButtonTouchUpInside() {
    validator.validate(self)
  }
  
  func validationSuccessful() {
    
    func updateUI(isEnabled: Bool = true,
                  showActivityIndicator: Bool = false,
                  error: Error? = nil) {
      
      emailAddressTextField.isEnabled = isEnabled
      passwordTextField.isEnabled = isEnabled
      loginButton.isEnabled = isEnabled
      if showActivityIndicator {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
      
      if let error = error {
        
        // TODO: log error message
        print(error.localizedDescription)
        
        let alert = UIAlertController(
          title: "Login Failure",
          message: "Invalid email address and/or password.",
          preferredStyle: .alert)
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .`default`))
        present(alert, animated: true, completion: nil)
        
      }
      
    }
    
    updateUI(isEnabled: false, showActivityIndicator: true)
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    // TODO: URL needs to come from configuration
    let loginService = LoginService(baseURL: URL(string: "http://0.0.0.0:8080/api/v1")!)
    let loginRequest = LoginService.LoginRequest(email: email, password: password)
    
    func responseHandler(response: LoginService.LoginResponse) {
  
      switch response {
        
      case let .success(userToken):
        // TODO: segue to the next page
        print(userToken)
        
      case let .failure(error):
        updateUI(error: error)
      
      }
    
    }
    
    do {
      try loginService.login(request: loginRequest, responseHandler: responseHandler)
    } catch let error {
      updateUI(error: error)
    }

  }
  
  func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    
    var errorMessages: [String] = []
    for (field, error) in errors {
      
      switch field {
      case let field as UITextField where field == emailAddressTextField:
        errorMessages.append("Email Address: \(error.errorMessage)")
      case let field as UITextField where field == passwordTextField:
        errorMessages.append("Password: \(error.errorMessage)")
      default:
        // TODO: log error
        print("unexpected field")
      }
      
    }
    
    let alert = UIAlertController(
      title: "Input Error",
      message: errorMessages.joined(separator: "\n"),
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(
      title: "OK",
      style: .`default`))
    present(alert, animated: true, completion: nil)
    
  }
  
}


