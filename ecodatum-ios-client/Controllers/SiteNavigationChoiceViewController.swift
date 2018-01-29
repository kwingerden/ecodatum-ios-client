import SwiftValidator
import UIKit

class SiteNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var siteNameLabel: UILabel!
  
  @IBOutlet weak var addNewMeasurementButton: UIButton!

  @IBOutlet weak var viewMeasurementsButton: UIButton!

  override func viewDidLoad() {
  
    super.viewDidLoad()
  
    title = viewControllerManager.site!.name
    
    siteNameLabel.text = viewControllerManager.site!.name
    
    addNewMeasurementButton.roundedButton()
    viewMeasurementsButton.roundedButton()
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
   
    switch sender {
      
    case addNewMeasurementButton:
      viewControllerManager.performSegue(to: .addNewMeasurement)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


