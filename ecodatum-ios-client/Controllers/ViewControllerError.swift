import Foundation

enum ViewControllerError: Error {
  
  case noAuthenticationToken
  case noOrganizationIdentifier
  case noUserOrganizations
  case noOrganizationSites(name: String)
  case siteNameConflict(name: String)
  
}

extension ViewControllerError: LocalizedError {
  
  public var errorDescription: String? {
    
    switch self {
    
    case .noAuthenticationToken:
      return "Failed to obtain user authentication token."
    
    case .noOrganizationIdentifier:
      return "Failed to obtain organization identifier."
      
    case .noUserOrganizations:
      return "User does not belong to any Organizations."
      
    case let .noOrganizationSites(name):
      return "Organization \"\(name)\" does not have any sites. A new site needs to be created."
      
    case let .siteNameConflict(name):
      return "Site with name \"\(name)\" already exists."
    
    }
    
  }
  
}
