import Foundation
import UIKit

class BaseFormSheetDisplayable: BaseContentViewScrollable {

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var headerView: UIView!

  @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var bodyView: UIView!

  @IBOutlet weak var bodyViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var footerView: UIView!

  @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

  private var isHeaderViewRemoved: Bool = false
  
  private var isFooterViewRemoved: Bool = false
  
  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    var preferredHeight: CGFloat = 0
    if viewControllerManager.isFormSheetSegue {

      if viewControllerManager.formSheetSegue?.segueType == .view {

        if !isFooterViewRemoved {
          isFooterViewRemoved = true
          footerView.removeFromSuperview()
        }
        preferredHeight = headerViewHeightConstraint.constant +
          bodyViewHeightConstraint.constant

      } else {

        preferredHeight = headerViewHeightConstraint.constant +
          bodyViewHeightConstraint.constant +
          footerViewHeightConstraint.constant

      }

    } else {

      if !isHeaderViewRemoved {
        isHeaderViewRemoved = true
        headerView.removeFromSuperview()
      }
      preferredHeight = bodyViewHeightConstraint.constant +
        footerViewHeightConstraint.constant

    }

    preferredContentSize.width = min(
      contentViewWidthConstraint.constant + 20,
      scrollView.bounds.width)
    preferredContentSize.height = min(
      preferredHeight + 100,
      scrollView.bounds.height)

  }

  override func viewDidLayoutSubviews() {

    if viewControllerManager.isFormSheetSegue {

      scrollView.isScrollEnabled =
        contentView.frame.width + 20 >= scrollView.bounds.width ||
          contentView.frame.height + 20 >= scrollView.bounds.height

      if scrollView.isScrollEnabled {

        scrollView.contentSize = CGSize(
          width: contentView.frame.width,
          height: contentView.frame.height)
        scrollView.contentOffset = CGPoint(
          x: 0,
          y: -10)
        scrollView.contentInset = UIEdgeInsets(
          top: 10,
          left: 0,
          bottom: 10,
          right: 0)

      }

    } else {

      super.viewDidLayoutSubviews()

    }

  }

  @IBAction func touchUpInside(_ sender: UIButton) {
    if sender == cancelButton {
      dismiss(animated: true, completion: nil)
    }
  }

  private func removeView(_ view: UIView) {
    if view.isDescendant(of: self.view) {
      view.removeFromSuperview()
    }
  }
  
}
