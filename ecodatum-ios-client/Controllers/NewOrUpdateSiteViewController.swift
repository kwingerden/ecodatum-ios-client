import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateSiteViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var nameErrorLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var descriptionErrorLabel: UILabel!
  
  @IBOutlet weak var latitudeTextField: UITextField!
  
  @IBOutlet weak var latitudeErrorLabel: UILabel!
  
  @IBOutlet weak var longitudeTextField: UITextField!
  
  @IBOutlet weak var longitudeErrorLabel: UILabel!
  
  @IBOutlet weak var saveSiteButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    descriptionTextView.rounded()
    descriptionTextView.lightBordered()
    descriptionTextView.allowsEditingTextAttributes = true
    descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
    
    saveSiteButton.rounded()
    
    switch viewControllerManager.viewControllerSegue {
      
    case .newSite?:
      
      registerFieldValidation()
      enableFields()
      
    case .updateSite?:
      
      registerFieldValidation()
      updateFieldValues()
      enableFields()
      
    case .viewSite?:
      
      updateFieldValues()
      enableFields(false)

    default:
      
      let viewControllerSegue = viewControllerManager.viewControllerSegue?.rawValue ?? "Unknown"
      LOG.error("Unexpected view controller segue \(viewControllerSegue)")
      
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    guard let identifier = segue.identifier,
      let viewControllerSegue = ViewControllerSegue(rawValue: identifier) else {
        LOG.error("Failed to determine view controller segue")
        return
    }
    
    if viewControllerSegue == .siteNavigationChoice {
      
      if let viewController = segue.destination as? BaseNavigationChoice {
        viewController.isNavigationBarHidden = true
      }
      
    }
    
  }
  
  @IBAction override func touchUpInside(_ sender: UIButton) {

    super.touchUpInside(sender)
    if sender == saveSiteButton {
      validator.defaultValidate(validationSuccessful)
    }

  }

  private func registerFieldValidation() {
    
    validator.registerField(
      nameTextField,
      errorLabel: nameErrorLabel,
      rules: [RequiredRule()])
    validator.registerField(
      descriptionTextView,
      errorLabel: descriptionErrorLabel,
      rules: [RequiredRule()])
    validator.registerField(
      latitudeTextField,
      errorLabel: latitudeErrorLabel,
      rules: [RequiredRule(), DoubleRule("Invalid Latitude")])
    validator.registerField(
      longitudeTextField,
      errorLabel: longitudeErrorLabel,
      rules: [RequiredRule(), DoubleRule("Invalid Longitude")])
  
  }
  
  private func updateFieldValues() {
    
    if let site = viewControllerManager.site {
      
      nameTextField.text = site.name
      descriptionTextView.text = site.description
      latitudeTextField.text = String(site.latitude)
      longitudeTextField.text = String(site.longitude)
      
    }
    
  }
  
  private func enableFields(_ isEnabled: Bool = true) {
    
    nameTextField.isEnabled = isEnabled
    descriptionTextView.isEditable = isEnabled
    latitudeTextField.isEnabled = isEnabled
    longitudeTextField.isEnabled = isEnabled
    
  }
  
  private func validationSuccessful() {
    
    let name = nameTextField.text!
    let description = descriptionTextView.text!
    let latitude = Double(latitudeTextField.text!)!
    let longitude = Double(longitudeTextField.text!)!
    
    viewControllerManager.newOrUpdateSite(
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation) {
        if self.viewControllerManager.isFormSheetSegue {
          self.dismiss(animated: true, completion: nil)
        }
    }
  
  }
  
}


