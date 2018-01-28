import Foundation
import UIKit

class MainViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    
    do {
        
      try initialize()
      
      // Dramatic pause
      Timer.scheduledTimer(
        withTimeInterval: 1,
        repeats: false) {
          _ in
          self.viewControllerManager.main()
      }
      
    } catch let error {
    
      LOG.error(error.localizedDescription)
    
    }
    
  }
  
}
