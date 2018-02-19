import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateSiteViewController:
BaseViewController,
FormSheetCancelButtonHolder {
  
  @IBOutlet weak var cancelButton: FormSheetCancelButton!
  
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
    
    saveSiteButton.rounded()
    
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
    
    if let site = viewControllerManager.site,
      ViewControllerSegue.updateSite == viewControllerManager.viewControllerSegue {

      nameTextField.text = site.name
      descriptionTextView.text = site.description
      latitudeTextField.text = String(site.latitude)
      longitudeTextField.text = String(site.longitude)
    
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    validator.defaultValidate(validationSuccessful)
  }
  
  private func validationSuccessful() {
    
    let name = nameTextField.text!
    let description = descriptionTextView.text!
    let latitude = Double(latitudeTextField.text!)!
    let longitude = Double(longitudeTextField.text!)!
    
    var newSiteHandler: SiteHandler = viewControllerManager
    if let siteHandler = viewControllerManager.storyboardSegue?.source as? SiteHandler {
      newSiteHandler = siteHandler
    }
  
    let id = ViewControllerSegue.newSite == viewControllerManager.viewControllerSegue ?
      nil : viewControllerManager.site?.id
    viewControllerManager.newOrUpdateSite(
      id: id,
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation,
      siteHandler: newSiteHandler) {
        self.dismiss(animated: true, completion: nil)
    }
  
  }
  
}


