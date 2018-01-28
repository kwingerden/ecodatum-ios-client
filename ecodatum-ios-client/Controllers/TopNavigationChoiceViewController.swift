import Foundation
import UIKit

class TopNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var createNewSiteButton: UIButton!
  
  @IBOutlet weak var chooseExistingSiteButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
    
    createNewSiteButton.roundedButton()
    chooseExistingSiteButton.roundedButton()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
    
    switch sender {
      
    case createNewSiteButton:
      viewControllerManager.performSegue(
        from: self,
        to: .createNewSite)
      
    case chooseExistingSiteButton:
      viewControllerManager.performSegue(
        from: self,
        to: .chooseExistingSite)
      
    default:
      LOG.error("Unexpected button")
      
    }
    
  }
}

