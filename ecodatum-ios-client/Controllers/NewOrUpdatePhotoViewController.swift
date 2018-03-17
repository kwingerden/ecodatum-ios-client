import AVFoundation
import Foundation
import SwiftValidator
import UIKit

class NewOrUpdatePhotoViewController:
BaseViewController,
FormSheetCancelButtonHolder {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var openCameraButton: UIButton!
  
  @IBOutlet weak var openPhotoLibraryButton: UIButton!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var descriptionErrorLabel: UILabel!
  
  @IBOutlet weak var cancelButton: FormSheetCancelButton!
  
  @IBOutlet weak var savePhotoButton: UIButton!

  override func viewDidLoad() {
    
    super.viewDidLoad()

    imageView.darkBordered()

    openCameraButton.rounded()
    openPhotoLibraryButton.rounded()
    
    descriptionTextView.rounded()
    descriptionTextView.lightBordered()
    
    savePhotoButton.rounded()
    
    switch viewControllerManager.viewControllerSegue {
      
    case .newPhoto?:
      
      registerFieldValidation()
      enableFields()
      
    case .updatePhoto?:
      
      registerFieldValidation()
      updateFieldValues()
      enableFields()
      
    case .viewPhoto?:
      
      updateFieldValues()
      enableFields(false)
      savePhotoButton.isHidden = true
      
    default:
      
      let viewControllerSegue = viewControllerManager.viewControllerSegue?.rawValue ?? "Unknown"
      LOG.error("Unexpected view controller segue \(viewControllerSegue)")
      
    }
    
  }

  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
  
    switch sender {
      
    case openCameraButton:
      showImagePickerController(.camera)
      
    case openPhotoLibraryButton:
      showImagePickerController(.photoLibrary)

    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }

  private func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {

    if UIImagePickerController.isCameraDeviceAvailable(.rear) {

      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = sourceType
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)

    } else {

      LOG.error("No rear camera available")

    }

  }
  
  private func registerFieldValidation() {
    
    validator.registerField(
      descriptionTextView,
      errorLabel: descriptionErrorLabel,
      rules: [RequiredRule()])
    
  }
  
  private func updateFieldValues() {
    
    if let photo = viewControllerManager.photo {
      descriptionTextView.text = photo.description
    }
    
  }
  
  private func enableFields(_ isEnabled: Bool = true) {
    
    imageView.isUserInteractionEnabled = isEnabled
    descriptionTextView.isEditable = isEnabled
    
  }
  
  private func validationSuccessful() {
    
    let description = descriptionTextView.text!
    
    /*
    viewControllerManager.newOrUpdatePhoto(
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation) {
        if self.viewControllerManager.isFormSheetSegue {
          self.dismiss(animated: true, completion: nil)
        }
    }
    */
    
  }
  
}

extension NewOrUpdatePhotoViewController: UINavigationControllerDelegate {

}

extension NewOrUpdatePhotoViewController: UIImagePickerControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]){

    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      imageView.image = editedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = pickedImage
    }
    picker.dismiss(animated: true, completion: nil)

  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

}


