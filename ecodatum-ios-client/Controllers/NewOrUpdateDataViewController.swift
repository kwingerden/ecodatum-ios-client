import AVFoundation
import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {
  
  @IBOutlet weak var airButton: UIButton!
  
  @IBOutlet weak var airLabel: UILabel!
  
  @IBOutlet weak var soilButton: UIButton!
  
  @IBOutlet weak var soilLabel: UILabel!
  
  @IBOutlet weak var waterButton: UIButton!
  
  @IBOutlet weak var waterLabel: UILabel!
  
  @IBOutlet weak var bioticButton: UIButton!
  
  @IBOutlet weak var bioticLabel: UILabel!
  
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    saveButton.rounded()
    
    switch viewControllerManager.viewControllerSegue {
      
    case .newPhoto?:
      
      registerFieldValidation()
      enableFields()
      
    case .updatePhoto?:
      
      registerFieldValidation()
      updateFieldValues()
      enableFields()
      
    case .viewPhoto?:
      
      updateFieldValues()
      enableFields(false)
      
    default:
      
      let viewControllerSegue = viewControllerManager.viewControllerSegue?.rawValue ?? "Unknown"
      LOG.error("Unexpected view controller segue \(viewControllerSegue)")
      
    }
    
    updateDataButtons(airButton)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
 
  }
  
  @IBAction override func touchUpInside(_ sender: UIButton) {
    
    super.touchUpInside(sender)
    
    switch sender {
      
    case airButton, soilButton, waterButton, bioticButton:
      updateDataButtons(sender)
      
    case saveButton:
      validateInput()
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
  private func validateInput() {
    validator.defaultValidate(validationSuccessful)
  }
  
  private func registerFieldValidation() {
    
  }
  
  private func updateFieldValues() {
    
  }
  
  private func enableFields(_ isEnabled: Bool = true) {
    
  }
  
  private func validationSuccessful() {
    
  }
  
  private func updateDataButtons(_ selectedButton: UIButton) {
   
    let allViews: [UIView] = [
      airButton,
      airLabel,
      
      soilButton,
      soilLabel,
      
      waterButton,
      waterLabel,
      
      bioticButton,
      bioticLabel
      ]
    allViews.forEach {
      $0.alpha = 0.2
    }
    
    switch selectedButton {
      
    case airButton:
      airButton.alpha = 1
      airLabel.alpha = 1
      
    case soilButton:
      soilButton.alpha = 1
      soilLabel.alpha = 1
      
    case waterButton:
      waterButton.alpha = 1
      waterLabel.alpha = 1
      
    case bioticButton:
      bioticButton.alpha = 1
      bioticLabel.alpha = 1
      
    default:
      LOG.error("Unexpected button \(String(describing: selectedButton.titleLabel?.text))")
      
    }
    
  }
  
  override func postAsyncUIOperation() {
    
    super.postAsyncUIOperation()
    
    if viewControllerManager.isFormSheetSegue {
      dismiss(animated: true, completion: nil)
    }
    
  }
  
}


