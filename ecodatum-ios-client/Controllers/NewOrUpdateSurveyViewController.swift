import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateSurveyViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var saveButton: UIButton!
    
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
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    guard let identifier = segue.identifier,
      let viewControllerSegue = ViewControllerSegue(rawValue: identifier) else {
        LOG.error("Failed to determine view controller segue")
        return
    }
    
    if viewControllerSegue == .surveyNavigationChoice {
      
      if let viewController = segue.destination as? BaseNavigationChoice {
        viewController.isNavigationBarHidden = true
      }
      
    }
    
  }
  
  @IBAction func datePickerChange() {
    dateLabel.text = "Date: \(Formatter.basic.string(from: datePicker.date))"
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



