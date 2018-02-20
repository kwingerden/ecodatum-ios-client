import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleSiteUpdate(site: Site)
  
}

protocol SurveyHandler {

  func handleNewSurvey(survey: Survey)

  func handleSurveyUpdate(survey: Survey)

}



