import Foundation
import UIKit

class TopNavigationChoiceViewController: BaseViewController {
  
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
      vcm?.performSegue(from: self, to: .createNewSite)
      
    case addNewMeasurementButton:
      vcm?.performSegue(from: self, to: .addNewMeasurement)
      
    default:
      LOG.error("Unexpected button")
      
    }
    
  }
}

