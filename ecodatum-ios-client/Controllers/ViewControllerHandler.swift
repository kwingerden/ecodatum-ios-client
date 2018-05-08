import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleUpdatedSite(site: Site)

  func handleDeletedSite(site: Site)
  
}

protocol EcoDataHandler {

  func handleNewEcoData(ecoData: EcoData)

  func handleUpdatedEcoData(ecoData: EcoData)

  func handleDeletedEcoData(ecoData: EcoData)

}


