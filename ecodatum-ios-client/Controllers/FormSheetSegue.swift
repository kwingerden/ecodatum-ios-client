import Foundation
import UIKit

class FormSheetSegue: UIStoryboardSegue {

  enum SegueType {
    case new
    case edit
    case view
  }

  var segueType: SegueType!

}
