import Foundation
import Hydra
import SVProgressHUD
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
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
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
    
    view.isUserInteractionEnabled = false
    activityIndicator.startAnimating()
    
    let name = nameTextField.text!
    let description = descriptionTextView.text!
    let latitude = latitudeTextField.text!
    let longitude = longitudeTextField.text!
    
    do {
      
      if let vcm = vcm,
        let authenticatedUser = vcm.authenticatedUser {
        
        func createNewSite(
          _ organizations: [ViewControllerManager.Organization])
          throws -> Promise<CreateNewSiteResponse> {
          
          // Just return the first organization since users are assumed to
          // belong to one organization at the moment.
          guard organizations.count == 1 else {
            throw ViewControllerError.unexpectedNumberOfUserOrganizations
          }
          let organization = organizations[0]
          return try vcm.createNewSite(
            token: authenticatedUser.token,
            organizationId: organization.id,
            name: name,
            description: description,
            latitude: latitude.toDouble()!,
            longitude: longitude.toDouble()!)
          
        }
        
        try vcm.getUserOrganizations(
          token: authenticatedUser.token,
          userId: authenticatedUser.userId)
          .then(in: .main, createNewSite)
          .then(in: .main) {
            response in
            LOG.debug(response)
            self.vcm?.performSegue(
              from: self,
              to: .addNewMeasurement,
              context: response)
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
      
    } catch let error {
      LOG.error(error.localizedDescription)
    }
    
  }
  
}


