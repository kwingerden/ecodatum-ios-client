import Foundation

enum ViewControllerError: Error {
  
  case noAbioticFactorIdentifier
  case noAuthenticationToken
  case noMeasurementUnitIdentifier
  case noOrganizationIdentifier
  case noOrganizationSites(name: String)
  case noSiteIdentifier
  case noSurveyIdentifier
  case noUserOrganizations
  case siteNameConflict(name: String)
  
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
      
    case .noOrganizationIdentifier:
      return "Failed to obtain organization identifier."

    case let .noOrganizationSites(name):
      return "Organization \"\(name)\" does not have any sites. A new site needs to be created."
      
    case .noSiteIdentifier:
      return "Failed to obtain site identifier."
      
    case .noSurveyIdentifier:
      return "Failed to obtain survey identifier."
      
    case .noUserOrganizations:
      return "User does not belong to any Organizations."
      
    case let .siteNameConflict(name):
      return "Site with name \"\(name)\" already exists."
    
    }
    
  }
  
}
