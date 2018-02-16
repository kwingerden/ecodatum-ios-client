import SwiftValidator
import UIKit

class SiteNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var siteNameLabel: UILabel!
  
  @IBOutlet weak var startNewSurveyButton: UIButton!

  @IBOutlet weak var viewExistingSurveysButton: UIButton!

  override func viewDidLoad() {
  
    super.viewDidLoad()
  
    title = viewControllerManager.site!.name
    
    siteNameLabel.text = viewControllerManager.site!.name
    
    startNewSurveyButton.rounded()
    viewExistingSurveysButton.rounded()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
   
    switch sender {
      
    case startNewSurveyButton:
      viewControllerManager.startNewSurvey(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


