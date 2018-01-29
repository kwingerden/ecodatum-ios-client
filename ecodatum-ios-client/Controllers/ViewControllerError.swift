import Foundation

enum ViewControllerError: Error {
  
  case noAuthenticationToken
  case noOrganizationIdentifier
  case noUserOrganizations
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
      
    case let .siteNameConflict(name):
      return "Site with name \"\(name)\" already exists."
    
    }
    
  }
  
}
