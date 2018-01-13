import Foundation
import UIKit

class MainViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    vcm?.performSegue(self, from: .main, to: .welcome)
  }

}

