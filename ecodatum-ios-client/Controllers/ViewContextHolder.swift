import Foundation
import UIKit

protocol OrganizationHolder {
  
  var organization: Organization! { set get }
  
}

protocol OrganizationsHolder {
  
  var organizations: [Organization]! { set get }
  
}

protocol SegueViewControllerHolder {
  
  var segueViewController: BaseViewController! { set get }
  
}
