import Foundation
import UIKit

class BaseContentViewScrollable: BaseViewController {

  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var contentView: UIView!

  private static let topInset = UIEdgeInsets(
    top: 100,
    left: 0,
    bottom: 0,
    right: 0)

  override func viewDidLayoutSubviews() {
    adjustScrollView(
      width: view.bounds.width,
      height: view.bounds.height)
  }

  func adjustScrollView(
    width: CGFloat,
    height: CGFloat,
    contentInset: UIEdgeInsets? = BaseContentViewScrollable.topInset) {

    scrollView.isScrollEnabled =
      contentView.frame.width >= width ||
        contentView.frame.height >= height

    if scrollView.isScrollEnabled {

      if let contentInset = contentInset {
        scrollView.contentInset = contentInset
      }
      scrollView.contentSize = CGSize(
        width: contentView.frame.width,
        height: contentView.frame.height)

    }

  }

}