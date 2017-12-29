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
    
    let email = emailAddressTextField.text!
    let password = passwordTextField.text!
    let loginService = LoginService(baseURL: URL(string: "http://0.0.0.0:8080/api/v1")!)
    let loginRequest = LoginService.LoginRequest(email: email, password: password)
    let callback = {
      (response: LoginService.LoginResponse) in
      switch response {
      case let .success(userToken):
        print(userToken)
      case let .failure(error):
        print(error.localizedDescription)
      }
    }
    do {
      try loginService.login(request: loginRequest, callback: callback)
    } catch let error {
      print(error.localizedDescription)
    }
  
  }
  
}


