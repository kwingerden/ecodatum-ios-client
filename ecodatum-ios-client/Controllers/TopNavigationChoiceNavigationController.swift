import Foundation
import UIKit

class TopNavigationChoiceNavigationController: UINavigationController, OrganizationHolder {
  
  var organization: Organization!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let viewController = viewControllers[0] as! TopNavigationChoiceViewController
    viewController.organization = organization
  }
  
}
