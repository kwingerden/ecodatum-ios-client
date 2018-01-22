import Foundation
import SwiftValidator

extension Validator {
  
  func defaultSuccessStyleTransformer(rule: ValidationRule) {
    
    if let view = rule.field as? UIView {
      view.layer.borderColor = UIColor.green.cgColor
      view.layer.borderWidth = 0.5
      rule.errorLabel?.text = nil
      rule.errorLabel?.isHidden = true
    }
    
  }
  
  func defaultErrorStyleTransformer(error: ValidationError) {
    
    if let view = error.field as? UIView {
      view.layer.borderColor = UIColor.red.cgColor
      view.layer.borderWidth = 1.0
      error.errorLabel?.text = error.errorMessage
      error.errorLabel?.isHidden = false
    }
    
  }
  
  func defaultStyleTransformers() {
    styleTransformers(
      success: defaultSuccessStyleTransformer,
      error: defaultErrorStyleTransformer)
  }
  
  typealias ValidationSuccessful = () -> Void
  
  private class DefaultValidationDelegate: ValidationDelegate {
    
    let callback: ValidationSuccessful
    
    init(_ callback: @escaping ValidationSuccessful) {
      self.callback = callback
    }
    
    func validationSuccessful() {
      callback()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
      // validation failures are handled with default validator styleTransformers
    }
    
  }
  
  func defaultValidate(_ validationSuccessful: @escaping ValidationSuccessful) {
    validate(DefaultValidationDelegate(validationSuccessful))
  }
  
}
