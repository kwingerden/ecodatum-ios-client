import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleUpdatedSite(site: Site)

  func handleDeletedSite(site: Site)
  
}


