import UIKit

extension UIButton {
  
  func roundedButton() {
    
    let bezierPath = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
      cornerRadii: CGSize(width: 8.0, height: 8.0))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = bounds
    maskLayer.path = bezierPath.cgPath
    layer.mask = maskLayer
    
  }
  
}
