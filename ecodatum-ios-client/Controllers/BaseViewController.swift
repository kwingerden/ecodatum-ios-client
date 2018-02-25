import Foundation
import SwiftValidator
import UIKit

class BaseViewController: UIViewController, ViewControllerManagerHolder {
  
  var viewControllerManager: ViewControllerManager!
  
  let validator = Validator()
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    validator.defaultStyleTransformers()
  
  }
  
  func initialize() throws {
    
    let databasePool = try DatabaseHelper.defaultDatabasePool(true)
    let databaseManager = try DatabaseManager(databasePool)
    let networkManager = NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL)
    let serviceManager = ServiceManager(
      databaseManager: databaseManager,
      networkManager: networkManager)
    let viewContext = ViewContext()
  
    viewControllerManager = ViewControllerManager(
      viewController: self,
      viewContext: viewContext,
      serviceManager: serviceManager)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    if var viewControllerManagerHolder = segue.destination as? ViewControllerManagerHolder {
      viewControllerManagerHolder.viewControllerManager = ViewControllerManager(
        newViewController: segue.destination,
        storyboardSegue: segue,
        viewControllerManager: viewControllerManager)
    }
    
    /*
    if var segueSourceViewControllerHolder = segue.destination as? SegueSourceViewControllerHolder {
      segueSourceViewControllerHolder.segueSourceViewController = segue.source
    }
 */
    
  }
  
  func preAsyncUIOperation() {
    
    view.isUserInteractionEnabled = false
    if activityIndicator != nil {
      activityIndicator.startAnimating()
    }
    
  }
  
  func postAsyncUIOperation() {
    
    view.isUserInteractionEnabled = true
    if activityIndicator != nil {
      activityIndicator.stopAnimating()
    }
    
  }
  
  
}
