import Foundation
import SwiftValidator
import UIKit

class LoginToAccountViewController: BaseViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var emailAddressErrorLabel: UILabel!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var passwordErrorLabel: UILabel!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var contentStackView: UIStackView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loginButton.rounded()
    
    validator.registerField(
      emailAddressTextField,
      errorLabel: emailAddressErrorLabel,
      rules: [RequiredRule(), EmailRule()])
    validator.registerField(
      passwordTextField,
      errorLabel: passwordErrorLabel,
      rules: [RequiredRule()])
    
  }
  
  override func viewDidLayoutSubviews() {
  
    let scrollViewWidth = view.bounds.width
    let scrollViewHeight = view.bounds.height - topBarHeightConstraint.constant
    scrollView.contentSize = CGSize(
      width: scrollViewWidth,
      height: scrollViewHeight)
    scrollView.isScrollEnabled =
      contentStackView.bounds.width >= scrollViewWidth ||
      contentStackView.bounds.height >= scrollViewHeight
    
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
