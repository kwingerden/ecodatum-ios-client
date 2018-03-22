import Foundation
import UIKit

class MainViewController: BaseContentViewScrollable {
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    
    do {
        
      try initialize()

      viewControllerManager.getMeasurementUnits {
        self.viewControllerManager.main()
      }

    } catch let error {
    
      LOG.error(error.localizedDescription)
    
    }
    
  }
  
}
