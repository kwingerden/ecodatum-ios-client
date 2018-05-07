import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleUpdatedSite(site: Site)

  func handleDeletedSite(site: Site)
  
}


protocol PhotoHandler {

  func handleNewPhoto(photo: Photo)

  func handleUpdatedPhoto(photo: Photo)

  func handleDeletedPhoto(photo: Photo)

}



