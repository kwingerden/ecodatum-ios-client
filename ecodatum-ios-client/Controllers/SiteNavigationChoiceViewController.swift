import SwiftValidator
import UIKit

class SiteNavigationChoiceViewController: BaseNavigationChoice {
  
  @IBOutlet weak var siteNameLabel: UILabel!
  
  @IBOutlet weak var collectNewDataButton: UIButton!
  
  @IBOutlet weak var viewExistingDataButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
  
    title = viewControllerManager.site!.name
    siteNameLabel.text = viewControllerManager.site!.name
    collectNewDataButton.rounded()
    viewExistingDataButton.rounded()
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
   
    switch sender {
      
    case collectNewDataButton:
      
      viewControllerManager.performSegue(
        from: self,
        to: .newEcoDatum)
      
    case viewExistingDataButton:
      
      viewControllerManager.performSegue(
        from: self,
        to: .ecoDatumChoice)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}


