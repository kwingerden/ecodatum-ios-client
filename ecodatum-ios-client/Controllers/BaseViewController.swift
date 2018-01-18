import Foundation
import UIKit

class BaseViewController: UIViewController {
  
  private static var _vcm: ViewControllerManager? = nil
  var vcm: ViewControllerManager? {
    get {
      if BaseViewController._vcm == nil {
        LOG.error("View Controller Manager not set")
      }
      return BaseViewController._vcm
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if BaseViewController._vcm == nil {
      do {
        BaseViewController._vcm = try ViewControllerManager()
      } catch let error {
        LOG.error(error.localizedDescription)
        // TODO: add some UI warning to user
      }
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
