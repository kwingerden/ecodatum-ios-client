import Foundation
import UIKit

protocol SiteHandler {
  
  func handleNewSite(site: Site)
  
  func handleUpdatedSite(site: Site)

  func handleDeletedSite(site: Site)
  
}

protocol SurveyHandler {

  func handleNewSurvey(survey: Survey)

  func handleUpdatedSurvey(survey: Survey)

  func handleDeletedSurvey(survey: Survey)

}



