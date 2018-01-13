import Foundation
import UIKit

class BaseViewController: UIViewController {
  
  private var _vcm: ViewControllerManager? = nil
  var vcm: ViewControllerManager? {
    get {
      if _vcm == nil {
        LOG.error("View Controller Manager not set")
      }
      return _vcm
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      _vcm = try ViewControllerManager()
    } catch let error {
      LOG.error(error.localizedDescription)
      // TODO: add some UI warning to user
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    vcm?.prepare(for: segue, sender: sender)
  }
  
}
