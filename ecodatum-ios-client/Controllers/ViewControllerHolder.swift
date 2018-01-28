import Foundation
import UIKit

protocol ViewControllerManagerHolder {
  
  var viewControllerManager: ViewControllerManager! { get set }
  
}

protocol SegueSourceViewControllerHolder {
  
  var segueSourceViewController: UIViewController! { get set }
  
}
