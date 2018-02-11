import Foundation
import SwiftyBeaver
import UIKit

// LOG

let LOG: SwiftyBeaver.Type = {
  
  let log = SwiftyBeaver.self
  let console = ConsoleDestination()
  let cloud = SBPlatformDestination(
    appID: SWIFTY_BEAVER_APP_ID,
    appSecret: SWIFTY_BEAVER_APP_SECRET,
    encryptionKey: SWIFTY_BEAVER_ENCRYPTION_KEY)
  
  log.addDestination(console)
  log.addDestination(cloud)
  
  return log
  
}()


let OLIVE_GREEN = UIColor.init(
  red: 210/255,
  green: 227/255,
  blue: 155/255,
  alpha: 1)

let DARK_GREEN = UIColor.init(
  red: 0,
  green: 143/255,
  blue: 0,
  alpha: 1)

