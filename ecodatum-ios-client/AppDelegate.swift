import SwiftyBeaver
import UIKit

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let console = ConsoleDestination()
    let cloud = SBPlatformDestination(
      appID: SWIFTY_BEAVER_APP_ID,
      appSecret: SWIFTY_BEAVER_APP_SECRET,
      encryptionKey: SWIFTY_BEAVER_ENCRYPTION_KEY)
    
    log.addDestination(console)
    log.addDestination(cloud)
    
    return true
  
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }

}

