import Foundation
import ImagePicker
import SwiftValidator
import UIKit

class NewOrUpdatePhotoViewController:
BaseViewController,
FormSheetCancelButtonHolder {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var descriptionErrorLabel: UILabel!
  
  @IBOutlet weak var cancelButton: FormSheetCancelButton!
  
  @IBOutlet weak var savePhotoButton: UIButton!
  
  private var imagePickerController: ImagePickerController!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(imageTapped(tapGestureRecognizer:)))
    imageView.addGestureRecognizer(tapGestureRecognizer)
    
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
  
  @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    
    imagePickerController = ImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.imageLimit = 1
    present(imagePickerController, animated: true, completion: nil)
    
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

extension NewOrUpdatePhotoViewController: ImagePickerDelegate {
  
  func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    imagePickerController.dismiss(animated: true, completion: nil)
  }
  
  func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    
    if images.count > 0 {
      imageView.image = images[0]
    }
    imagePickerController.dismiss(animated: true, completion: nil)
  
  }
  
  func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    imagePickerController.dismiss(animated: true, completion: nil)
  }
  
}





