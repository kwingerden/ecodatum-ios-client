import AVFoundation
import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateAudioClipViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var startRecordingButton: UIButton!
  
  @IBOutlet weak var stopRecordingButton: UIButton!
  
  @IBOutlet weak var playRecordingButton: UIButton!
  
  @IBOutlet weak var saveAudioClipButton: UIButton!

  private var audioFileURL: URL!

  private var audioRecorder: AVAudioRecorder!
  
  private var audioPlayer: AVAudioPlayer!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //saveAudioClipButton.rounded()
    
    switch viewControllerManager.viewControllerSegue {
      
    case .newAudioClip?:
      
      registerFieldValidation()
      enableFields()
      
    case .updateAudioClip?:
      
      registerFieldValidation()
      updateFieldValues()
      enableFields()
      
    case .viewAudioClip?:
      
      updateFieldValues()
      enableFields(false)
      saveAudioClipButton.isHidden = true
      
    default:
      
      let viewControllerSegue = viewControllerManager.viewControllerSegue?.rawValue ?? "Unknown"
      LOG.error("Unexpected view controller segue \(viewControllerSegue)")
      
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    
    do {
      if !(try AVAudioSession.sharedInstance().initialize()) {
        enableFields(false)
        LOG.warning("User did not give permission to record audio.")
      }
    } catch let error {
      LOG.error("Failed to initialize audio session: \(error.localizedDescription)")
    }
    
  }
  
  @IBAction override func touchUpInside(_ sender: UIButton) {

    super.touchUpInside(sender)

    if sender == playRecordingButton {
      
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
        audioPlayer.delegate = self
        if !audioPlayer.play() {
          LOG.warning("failed to play audio recording")
        }
      } catch let error {
        LOG.warning("Failed to create audio player: \(error.localizedDescription)")
      }
      
    } else if sender == startRecordingButton {

      audioFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent("audio")
      guard let audioFormat = AVAudioFormat(
        standardFormatWithSampleRate: 44100.0,
        channels: 2) else {
          LOG.warning("Failed to define audio format.")
        return
      }
      do {
        audioRecorder = try AVAudioRecorder(url: audioFileURL, format: audioFormat)
        audioRecorder.delegate = self
        if !audioRecorder.prepareToRecord() {
          LOG.error("Failed to prepare audio recorder")
        }
        if !audioRecorder.record() {
          LOG.error("Failed to being recording audio")
        }
      } catch let error {
        LOG.error("Failed to create audio recorder: \(error.localizedDescription)")
      }
      
    } else if sender == stopRecordingButton {

      audioRecorder.stop()

    }
    
  }
  
  private func registerFieldValidation() {
    
    /*
    validator.registerField(
      descriptionTextView,
      errorLabel: descriptionErrorLabel,
      rules: [RequiredRule()])
    */
    
  }
  
  private func updateFieldValues() {
    
    /*
    if let photo = viewControllerManager.photo {
      
      descriptionTextView.text = photo.description
      
    }
     */
    
  }
  
  private func enableFields(_ isEnabled: Bool = true) {
    
    //imageView.isUserInteractionEnabled = isEnabled
    //descriptionTextView.isEditable = isEnabled
    
  }
  
  private func validationSuccessful() {
    
    //let description = descriptionTextView.text!
    
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

extension NewOrUpdateAudioClipViewController: AVAudioPlayerDelegate {
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    LOG.debug("audioPlayerDidFinishPlaying")
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    LOG.debug("audioPlayerDecodeErrorDidOccur")
  }
  
  func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    LOG.debug("audioPlayerBeginInterruption")
  }
  
  func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
    LOG.debug("audioPlayerEndInterruption")
  }
  
}

extension NewOrUpdateAudioClipViewController: AVAudioRecorderDelegate {
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    LOG.debug("audioRecorderDidFinishRecording")
  }
  
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    LOG.debug("audioRecorderEncodeErrorDidOccur")
  }

  func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
    LOG.debug("audioRecorderBeginInterruption")
  }
  
  func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
    LOG.debug("audioRecorderEndInterruption")
  }
  
}






