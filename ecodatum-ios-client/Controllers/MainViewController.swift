import Foundation
import UIKit

class MainViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
  
    super.viewDidAppear(animated)
    
    // Dramatic pause
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
      _ in
      if let _ = self.vcm?.authenticatedUser {
        self.vcm?.performSegue(from: self, to: .topNavigation)
      } else {
        self.vcm?.performSegue(from: self, to: .welcome)
      }
    }
  
  }

}

