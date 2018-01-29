import Foundation
import UIKit

class TopNavigationChoiceNavigationController: UINavigationController, ViewControllerManagerHolder {
  
  var viewControllerManager: ViewControllerManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let viewController = viewControllers[0] as! TopNavigationChoiceViewController
    viewController.viewControllerManager = ViewControllerManager(
      newViewController: viewController,
      viewControllerManager: viewControllerManager)
  }
  
}
