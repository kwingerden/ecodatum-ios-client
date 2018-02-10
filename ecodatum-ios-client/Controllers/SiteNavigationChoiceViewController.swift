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
    
    addNewMeasurementButton.rounded()
    viewMeasurementsButton.rounded()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
   
    switch sender {
      
    case addNewMeasurementButton:
      viewControllerManager.getAbioticFactors(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


