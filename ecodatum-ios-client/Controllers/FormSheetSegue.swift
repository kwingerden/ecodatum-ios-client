import Foundation
import UIKit

class FormSheetSegue: UIStoryboardSegue {
  
  override func perform() {

    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width * 0.75
    let screenHeight = screenSize.height * 0.75
    destination.preferredContentSize = CGSize(
      width: screenWidth,
      height: screenHeight)
    
    super.perform()
    
    if let cancelButtonHolder = destination as? FormSheetCancelButtonHolder {
      cancelButtonHolder.cancelButton.initialize(destination)
    }
    
  }
  
}


