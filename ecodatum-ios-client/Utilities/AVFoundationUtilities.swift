import AVFoundation
import Foundation
import UIKit

extension AVAudioSession {

  func initialize() throws -> Bool {

    var isPermissionGranted = false
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(
      AVAudioSessionCategoryPlayAndRecord,
      with: AVAudioSessionCategoryOptions.defaultToSpeaker)
    session.requestRecordPermission {
      isPermissionGranted = $0
    }

    return isPermissionGranted
  
  }
  
}

class PhotoCaptureManager {
  
  private var capturePreview: UIView!
  
  private let captureSession = AVCaptureSession()
  
  private let capturePhotoOutput = AVCapturePhotoOutput()
  
  private let capturePhotoSettings = AVCapturePhotoSettings(
    format: [
      AVVideoCodecKey: AVVideoCodecType.jpeg,
      ])
  
  enum Errors: Error {
    case noDefaultCameraAvailable
    case permissionNotGranted
  }
  
  init(_ capturePreview: UIView) {
    self.capturePreview = capturePreview
  }
  
  func startPreview() throws {
    
    AVCaptureDevice.requestAccess(for: .video) {
      accessGranted in
      if accessGranted {
        DispatchQueue.main.async {
          do {
            try self.doDefaultPreview(self.capturePreview)
          } catch let error {
            print("Error: \(error.localizedDescription)")
          }
        }
      } else {
        print("Error: camera permission not granted.")
      }
    }
    
  }
  
  func capturePhoto(_ delegate: AVCapturePhotoCaptureDelegate) {
    
    capturePhotoOutput.capturePhoto(
      with: capturePhotoSettings,
      delegate: delegate)
    
    captureSession.stopRunning()
    
  }
  
  func openCamera(
    _ viewController: UIViewController,
    _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    
    if UIImagePickerController.isCameraDeviceAvailable(.rear) {
      
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = delegate
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = true
      imagePicker.cameraCaptureMode = .photo
      viewController.present(imagePicker, animated: true, completion: nil)
      
    }
    
  }
  
  func openPhotoLibrary(
    _ viewController: UIViewController,
    _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = delegate
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
      viewController.present(imagePicker, animated: true, completion: nil)
      
    }
    
  }
  
  private func doDefaultPreview(_ view: UIView) throws {
    
    captureSession.sessionPreset = .photo
    
    guard let captureDevice = AVCaptureDevice.default(for: .video) else {
      throw Errors.noDefaultCameraAvailable
    }
    let photoInput = try AVCaptureDeviceInput(device: captureDevice)
    
    guard captureSession.canAddInput(photoInput) else {
      throw Errors.noDefaultCameraAvailable
    }
    captureSession.addInput(photoInput)
    
    guard captureSession.canAddOutput(capturePhotoOutput) else {
      throw Errors.noDefaultCameraAvailable
    }
    captureSession.addOutput(capturePhotoOutput)
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.videoGravity = .resize
    previewLayer.connection?.videoOrientation = .portrait
    previewLayer.frame = view.bounds
    view.layer.insertSublayer(previewLayer, at: 0)
    
    captureSession.startRunning()
    
  }
  
}


