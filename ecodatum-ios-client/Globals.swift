import Foundation
import SwiftyBeaver
import SwiftyJSON

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


