import Foundation
import UIKit

class MainViewController: BaseContentViewScrollable {
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    
    do {
        
      try initialize()

      viewControllerManager.getEcoDatumFactors {
        self.viewControllerManager.getMediaTypes {
          self.viewControllerManager.getQualitativeObservationTypes() {
            self.viewControllerManager.getQuantitativeObservationTypes() {
              self.viewControllerManager.main()
            }
          }
        }
      }

    } catch let error {
    
      LOG.error(error.localizedDescription)
    
    }
    
  }
  
}
