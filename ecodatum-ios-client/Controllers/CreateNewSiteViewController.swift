import Foundation
import SwiftValidator
import UIKit

class CreateNewSiteViewController: BaseViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var nameErrorLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var descriptionErrorLabel: UILabel!
  
  @IBOutlet weak var latitudeTextField: UITextField!
  
  @IBOutlet weak var latitudeErrorLabel: UILabel!
  
  @IBOutlet weak var longitudeTextField: UITextField!
  
  @IBOutlet weak var longitudeErrorLabel: UILabel!
  
  @IBOutlet weak var createNewSiteButton: UIButton!
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    descriptionTextView.roundedTextView()
    createNewSiteButton.roundedButton()
    
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
    let latitude = latitudeTextField.text!
    let longitude = longitudeTextField.text!
    
    /*
    viewControllerManager.createNewSite(
      token: viewControllerManager.authenticatedUser!.token,
      organizationId: viewControllerManager.organization!.id,
      name: name,
      description: description,
      latitude: latitude.toDouble()!,
      longitude: longitude.toDouble()!)
      .then(in: .main) {
        site in
        //let organizationSite = OrganizationSite(
        //  organization: self.organization,
        //  site: site)
        self.viewControllerManager.performSegue(to: .addNewMeasurement)
      }.catch(in: .main) {
        error in
        if self.viewControllerManager.isConflictError(error) {
          SVProgressHUD.defaultShowError("Site \(name) already exists.")
        } else {
          self.viewControllerManager.handleError(error)
        }
      }
      .always(in: .main, body: postAsyncUIOperation)
 */
    
  }
  
}


