import UIKit

class BaseNavigationChoice: BaseContentViewScrollable {

  var isNavigationBarHidden = false
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = isNavigationBarHidden
    
  }
  
}
