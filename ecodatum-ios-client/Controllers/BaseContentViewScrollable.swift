import Foundation
import UIKit

class BaseContentViewScrollable: BaseViewController {

  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var contentView: UIView!

  override func viewDidLayoutSubviews() {

    scrollView.isScrollEnabled =
      contentView.frame.width + 20 >= scrollView.bounds.width ||
        contentView.frame.height + 20 >= scrollView.bounds.height

    if scrollView.isScrollEnabled {

      scrollView.contentSize = CGSize(
        width: contentView.frame.width,
        height: contentView.frame.height)
      scrollView.contentOffset = CGPoint(
        x: 0,
        y: -100)
      scrollView.contentInset = UIEdgeInsets(
        top: 100,
        left: 0,
        bottom: 100,
        right: 0)

    }

  }

}
