import UIKit

extension UIButton {
  
  func roundedButton() {
    
    let maskPAth1 = UIBezierPath(roundedRect: bounds,
                                 byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                 cornerRadii:CGSize(width:8.0, height:8.0))
    let maskLayer1 = CAShapeLayer()
    maskLayer1.frame = bounds
    maskLayer1.path = maskPAth1.cgPath
    layer.mask = maskLayer1
  
  }
  
}
