import Foundation
import UIKit

extension UIImage {

  func base64Encode() -> Base64Encoded? {
    if let jpeg = UIImageJPEGRepresentation(self, 1.0) {
      return jpeg.base64EncodedString()
    }
    return nil
  }

  static func base64Decode(_ jpeg: Base64Encoded) -> UIImage? {
    if let data = jpeg.base64Decode() {
      return UIImage(data: data)
    }
    return nil
  }

  var centeredSquareRect: CGRect {
    let length = min(size.width, size.height)
    let x = (size.width - length) / 2
    let y = (size.height - length) / 2
    return CGRect(
      x: x,
      y: y,
      width: length,
      height: length)
  }

  func crop(to rect: CGRect) -> UIImage? {

    var transform: CGAffineTransform
    switch imageOrientation {

    case .left:
      transform = CGAffineTransform(
        rotationAngle: toRadians(90))
        .translatedBy(
          x: 0,
          y: -size.height)

    case .right:
      transform = CGAffineTransform(
        rotationAngle: toRadians(-90))
        .translatedBy(
          x: -size.width,
          y: 0)

    case .down:
      transform = CGAffineTransform(
        rotationAngle: toRadians(-180))
        .translatedBy(
          x: -size.width,
          y: -size.height)

    default:
      transform = .identity

    }
    transform = transform.scaledBy(x: scale, y: scale)

    guard let croppedImage = self.cgImage?.cropping(to: rect.applying(transform)) else {
      return nil
    }

    return UIImage(
      cgImage: croppedImage,
      scale: scale,
      orientation: imageOrientation)

  }

  private func toRadians(_ degrees: Double) -> CGFloat {
    return CGFloat(degrees / 180.0 * .pi)
  }

}