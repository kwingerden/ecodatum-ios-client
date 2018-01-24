import Foundation
import UIKit

class MainViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    
    do {
      
      if BaseViewController.serviceManager == nil {
        
        let databasePool = try DatabaseHelper.defaultDatabasePool(
          DROP_AND_RECREATE_ECODATUM_DATABASE_FILE)
        let databaseManager = try DatabaseManager(databasePool)
        let networkManager = NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL)
        BaseViewController.serviceManager = ServiceManager(
          databaseManager: databaseManager,
          networkManager: networkManager)
      
      }
      
      // Dramatic pause
      Timer.scheduledTimer(
        withTimeInterval: 1,
        repeats: false) {
          _ in
          self.checkAuthenticatedUser()
      }
      
    } catch let error {
    
      LOG.error(error.localizedDescription)
    
    }
    
  }
  
}

