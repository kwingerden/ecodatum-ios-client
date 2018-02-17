import SwiftValidator
import UIKit

class SurveyNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var surveyDateLabel: UILabel!
  
  @IBOutlet weak var addNewMeasurementButton: UIButton!
  
  @IBOutlet weak var viewExistingMeasurementsButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    surveyDateLabel.text = Formatter.basic.string(
      from: viewControllerManager.survey!.date)
    
    addNewMeasurementButton.rounded()
    viewExistingMeasurementsButton.rounded()
    
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
  
    case viewExistingMeasurementsButton:
      viewControllerManager.getMeasurements(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}



