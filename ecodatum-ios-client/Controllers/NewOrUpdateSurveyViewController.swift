import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateSurveyViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var saveButton: UIButton!
  
  private var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.medium
    return dateFormatter
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    descriptionTextView.rounded()
    descriptionTextView.lightBordered()
    descriptionTextView.allowsEditingTextAttributes = true
    descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
    
    saveButton.rounded()

    switch viewControllerManager.viewControllerSegue {

    case .newSurvey?:

      enableFields()

    case .updateSurvey?:

      updateFieldValues()
      enableFields()

    case .viewSurvey?:

      updateFieldValues()
      enableFields(false)

    default:

      let viewControllerSegue = viewControllerManager.viewControllerSegue?.rawValue ?? "Unknown"
      LOG.error("Unexpected view controller segue \(viewControllerSegue)")

    }
    
    datePickerChange()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  @IBAction func datePickerChange() {
    dateLabel.text = "Date: \(dateFormatter.string(from: datePicker.date))"
  }
  
  @IBAction override func touchUpInside(_ sender: UIButton) {

    super.touchUpInside(sender)

    if sender == saveButton {

      let date = datePicker.date
      let description = descriptionTextView.text!

      viewControllerManager.newOrUpdateSurvey(
        date: date,
        description: description,
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation) {
        if self.viewControllerManager.isFormSheetSegue {
          self.dismiss(animated: true, completion: nil)
        }
      }

    }
    
  }

  private func updateFieldValues() {

    if let survey = viewControllerManager.survey {

      datePicker.date = survey.date
      descriptionTextView.text = survey.description

    }

  }

  private func enableFields(_ isEnabled: Bool = true) {

    datePicker.isEnabled = isEnabled
    descriptionTextView.isEditable = isEnabled

  }
  
}



