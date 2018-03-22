import Foundation
import UIKit

class TopNavigationChoiceViewController: BaseContentViewScrollable {
  
  @IBOutlet weak var organizationNameLabel: UILabel!
  
  @IBOutlet weak var createNewSiteButton: UIButton!
  
  @IBOutlet weak var chooseExistingSiteButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
    
    title = viewControllerManager.organization!.name
    
    organizationNameLabel.text = viewControllerManager.organization!.name
   
    createNewSiteButton.rounded()
    chooseExistingSiteButton.rounded()

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
        to: .newSite)
      
    case chooseExistingSiteButton:
      viewControllerManager.chooseExistingSite(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unexpected button")
      
    }
    
  }
}

