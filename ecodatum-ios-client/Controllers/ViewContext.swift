import Foundation

class ViewContext {
  
  enum Key {
    
    case organization
    case organizations
    
    case site
    case sites
  
  }

  enum Value {
    
    case organization(Organization)
    case organizations([Organization])
    
    case site(Site)
    case sites([Site])
    
  }
  
  var state: [Key: Value] = [:]
  
}


