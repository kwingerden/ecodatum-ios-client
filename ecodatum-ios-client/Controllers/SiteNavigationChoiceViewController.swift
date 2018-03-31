import SwiftValidator
import UIKit

class SiteNavigationChoiceViewController: BaseNavigationChoice {
  
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
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
   
    switch sender {
      
    case startNewSurveyButton:
      
      viewControllerManager.performSegue(
        from: self,
        to: .newSurvey)
      
    case viewExistingSurveysButton:
      
      viewControllerManager.chooseExistingSurvey(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


