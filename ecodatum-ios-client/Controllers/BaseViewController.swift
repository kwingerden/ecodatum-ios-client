import Foundation
import SwiftValidator
import UIKit

class BaseViewController: UIViewController, ViewControllerManagerHolder {
  
  var viewControllerManager: ViewControllerManager!
  
  let validator = Validator()
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var contentView: UIView!
  
  private static let zeroInsets = UIEdgeInsets(
    top: 0,
    left: 0,
    bottom: 0,
    right: 0)
  
  private static let topInset = UIEdgeInsets(
    top: 100,
    left: 0,
    bottom: 0,
    right: 0)
  
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
    
  }
  
  override func viewDidLayoutSubviews() {

    adjustScrollView(
      width: view.bounds.width,
      height: view.bounds.height)
  
  }
  
  func adjustScrollView(width: CGFloat, height: CGFloat) {

    // Only certain views have a scroll view. If not, then ignore.
    if self is TopNavigationViewController ||
      self is AccountViewController {
      return
    }

    scrollView.isScrollEnabled =
      contentView.frame.width >= width ||
      contentView.frame.height >= height

    if scrollView.isScrollEnabled &&
      UIDevice.current.orientation.isLandscape {
    
      scrollView.contentInset = BaseViewController.topInset
      scrollView.contentSize = CGSize(
        width: contentView.frame.width,
        height: contentView.frame.height)
    
    } else {
      
      scrollView.contentInset = BaseViewController.zeroInsets
    
    }
    
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

