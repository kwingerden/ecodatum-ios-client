import Foundation
import UIKit

class MainViewController: BaseContentViewScrollable {
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    
    do {
      try initialize()
      try viewControllerManager.main()
    } catch let error {
      LOG.error(error.localizedDescription)
    }
    
  }
  
}
