import Foundation
import UIKit

class BaseFormSheetDisplayable: BaseContentViewScrollable {

  var isDisplayedAsFormSheet: Bool = false

  var formSheetSegueType: FormSheetSegue.SegueType!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

  @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var saveActivityHeightConstraint: NSLayoutConstraint!

  private static let topInset = UIEdgeInsets(
    top: 20,
    left: 0,
    bottom: 0,
    right: 0)

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    if isDisplayedAsFormSheet {

      cancelButton.isHidden = false

      let width = contentViewWidthConstraint.constant + 20
      var height = contentViewHeightConstraint.constant
      if formSheetSegueType == .view {
        height = height - saveActivityHeightConstraint.constant
      }
      preferredContentSize = CGSize(
        width: width,
        height: height)

    } else {

      cancelButton.isHidden = true

    }

  }

  override func viewDidLayoutSubviews() {

    adjustScrollView(
      width: view.bounds.width,
      height: view.bounds.height,
      contentInset: BaseFormSheetDisplayable.topInset)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {
  
    if sender == cancelButton {
      dismiss(animated: true, completion: nil)
    }
  
  }
  
}
