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

