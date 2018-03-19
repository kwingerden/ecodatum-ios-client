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

  private var hasPhotoBeenPicked: Bool = false

  override func viewDidLoad() {
    
    super.viewDidLoad()

    imageView.darkBordered()

    openCameraButton.rounded()
    openPhotoLibraryButton.rounded()
    
    descriptionTextView.rounded()
    descriptionTextView.lightBordered()
    descriptionTextView.allowsEditingTextAttributes = true
    descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
    
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

    case savePhotoButton:
      validateInput()

    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }

  private func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {

    if UIImagePickerController.isCameraDeviceAvailable(.rear) {

      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = sourceType
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)

    } else {

      LOG.error("No rear camera available")

    }

  }

  private func validateInput() {

    if hasPhotoBeenPicked {
      imageView.darkBordered()
    } else {
      imageView.errorBordered()
    }
    validator.defaultValidate(validationSuccessful)

  }

  private func registerFieldValidation() {
    
    validator.registerField(
      descriptionTextView,
      errorLabel: descriptionErrorLabel,
      rules: [RequiredRule()])
    
  }
  
  private func updateFieldValues() {
    
    if let photo = viewControllerManager.photo {
      imageView.image = UIImage.base64Decode(photo.base64Encoded)
      descriptionTextView.text = photo.description
    }
    
  }
  
  private func enableFields(_ isEnabled: Bool = true) {

    openCameraButton.isEnabled = isEnabled
    openPhotoLibraryButton.isEnabled = isEnabled
    descriptionTextView.isEditable = isEnabled
    
  }
  
  private func validationSuccessful() {

    guard let image = imageView.image else {
      LOG.error("Failed to obtain image from image view")
      return
    }

    guard let base64Encoded = image.base64Encode(),
          let description = descriptionTextView.text else {
      LOG.error("Failed to obtain base64 encoded image and description")
      return
    }

    viewControllerManager.newOrUpdatePhoto(
      base64Encoded: base64Encoded,
      description: description,
      preAsyncBlock: preAsyncUIOperation,
      postAsyncBlock: postAsyncUIOperation)
    
  }
  
}

extension NewOrUpdatePhotoViewController: UINavigationControllerDelegate {

}

extension NewOrUpdatePhotoViewController: UIImagePickerControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]){

    hasPhotoBeenPicked = true
    var image: UIImage = imageView.image!
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      image = pickedImage
    }
    imageView.image = image.crop(to: image.centeredSquareRect)
    picker.dismiss(animated: true, completion: nil)

  }


  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

}


