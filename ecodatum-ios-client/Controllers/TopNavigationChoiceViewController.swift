import Foundation
import UIKit

class TopNavigationChoiceViewController: BaseViewController, OrganizationHolder {
  
  var organization: Organization!
  
  @IBOutlet weak var createNewSiteButton: UIButton!
  
  @IBOutlet weak var addNewMeasurementButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
    
    createNewSiteButton.roundedButton()
    addNewMeasurementButton.roundedButton()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
    
    switch sender {
      
    case createNewSiteButton:
      performSegue(from: self,
                   to: .createNewSite,
                   viewContext: organization)
      
    case addNewMeasurementButton:
      performSegue(from: self,
                   to: .addNewMeasurement,
                   viewContext: organization)
      
    default:
      LOG.error("Unexpected button")
      
    }
    
  }
}

