import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateSurveyViewController:
BaseViewController,
FormSheetCancelButtonHolder {
  
  @IBOutlet weak var cancelButton: FormSheetCancelButton!
  
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
    
    saveButton.rounded()
    
    if let survey = viewControllerManager.survey,
      ViewControllerSegue.updateSurvey == viewControllerManager.viewControllerSegue {
      
      datePicker.date = survey.date
      descriptionTextView.text = survey.description
      
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
  
  @IBAction func touchUpInside(_ sender: UIButton) {

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



