import Foundation

enum ViewControllerError: Error {
  
  case noAbioticFactorIdentifier
  case noAuthenticationToken
  case noMeasurementUnitIdentifier
  case noMeasurementUnits
  case noOrganizationIdentifier
  case noOrganizationSites(name: String)
  case noSiteIdentifier
  case noSiteSurveys(name: String)
  case noSurveyIdentifier
  case noSurveyMeasurements(name: String)
  case noSurveyPhotos(date: Date)
  case noUserOrganizations
  case siteNameConflict(name: String)
  case noSiteData(name: String)
  
}

extension ViewControllerError: LocalizedError {
  
  public var errorDescription: String? {
    
    switch self {
    
    case .noAbioticFactorIdentifier:
      return "Failed to obtain abiotic factor identifier."
      
    case .noAuthenticationToken:
      return "Failed to obtain user authentication token."
    
    case .noMeasurementUnitIdentifier:
      return "Failed to obtain measurement unit identifier."

    case .noMeasurementUnits:
      return "There are no available measurement units."

    case .noOrganizationIdentifier:
      return "Failed to obtain organization identifier."

    case let .noOrganizationSites(name):
      return "Organization \"\(name)\" does not have any sites. A new site needs to be created."
      
    case .noSiteIdentifier:
      return "Failed to obtain site identifier."
      
    case let .noSiteSurveys(name):
      return "Site \"\(name)\" does not have any surveys. A new survey needs to be created."
      
    case .noSurveyIdentifier:
      return "Failed to obtain survey identifier."

    case let .noSurveyMeasurements(name):
      return "Survey \"\(name)\" does not have any measurements."
      
    case let .noSurveyPhotos(date):
      return "Survey \"\(Formatter.basic.string(from: date))\" does not have any photos."

    case .noUserOrganizations:
      return "User does not belong to any Organizations."
      
    case let .siteNameConflict(name):
      return "Site with name \"\(name)\" already exists."

    case let .noSiteData(name):
      return "Site \"\(name)\" does not have any data. New data needs to be collected."
    
    }
    
  }
  
}
