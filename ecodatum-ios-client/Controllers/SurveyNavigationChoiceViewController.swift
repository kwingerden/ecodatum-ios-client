import SwiftValidator
import UIKit

class SurveyNavigationChoiceViewController: BaseViewController {
  
  @IBOutlet weak var surveyDateLabel: UILabel!
  
  @IBOutlet weak var addNewMeasurementButton: UIButton!
  
  @IBOutlet weak var viewExistingMeasurementsButton: UIButton!

  @IBOutlet weak var addNewPhotoButton: UIButton!
  
  @IBOutlet weak var viewExistingPhotosButton: UIButton!

  @IBOutlet weak var addNewAudioClipButton: UIButton!
  
  @IBOutlet weak var viewExistingAudioClipsButton: UIButton!

  @IBOutlet weak var addNewNoteButton: UIButton!
  
  @IBOutlet weak var viewExistingNotesButton: UIButton!

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    surveyDateLabel.text = Formatter.basic.string(
      from: viewControllerManager.survey!.date)
    
    addNewMeasurementButton.rounded()
    viewExistingMeasurementsButton.rounded()
    
    addNewPhotoButton.rounded()
    viewExistingPhotosButton.rounded()
    
    addNewAudioClipButton.rounded()
    viewExistingAudioClipsButton.rounded()
    
    addNewNoteButton.rounded()
    viewExistingNotesButton.rounded()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
    
    switch sender {
      
    case addNewMeasurementButton:
      
      viewControllerManager.showPrimaryAbioticFactors()
  
    case viewExistingMeasurementsButton:
      
      viewControllerManager.getMeasurements(
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    case addNewPhotoButton:
      
      viewControllerManager.performSegue(to: .newPhoto)
      
    case viewExistingPhotosButton:
      break
      
    case addNewAudioClipButton:

      viewControllerManager.performSegue(to: .newAudioClip)

    case viewExistingAudioClipsButton:
      break
      
    case addNewNoteButton:
      break
      
    case viewExistingNotesButton:
      break
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}



