import Foundation
import UIKit

class FormSheetSegue: UIStoryboardSegue {

  enum SegueType {
    case new
    case edit
    case view
  }

  var segueType: SegueType!

  override func perform() {

    super.perform()

    if let formSheet = destination as? BaseFormSheetDisplayable {
      formSheet.isDisplayedAsFormSheet = true
      formSheet.formSheetSegueType = segueType
    }

  }
  
}

extension UIStoryboardSegue {
  
  var isFormSheetSegue: Bool {
    return self is FormSheetSegue
  }
  
}
