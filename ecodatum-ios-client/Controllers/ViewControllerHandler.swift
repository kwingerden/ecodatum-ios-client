import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleUpdatedSite(site: Site)

  func handleDeletedSite(site: Site)
  
}

protocol EcoDatumHandler {

  func handleNewEcoDatum(ecoDatum: EcoDatum)

  func handleUpdatedEcoDatum(ecoDatum: EcoDatum)

  func handleDeletedEcoDatum(ecoDatum: EcoDatum)

}


