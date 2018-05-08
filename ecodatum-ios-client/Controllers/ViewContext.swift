import Foundation

class ViewContext {
  
  enum Key {
    
    case organization
    case organizations
    case organizationMembers
    
    case site
    case sites

    case ecoDatum
    case ecoData
    
  }

  enum Value {
    
    case organization(Organization)
    case organizations([Organization])
    case organizationMembers([OrganizationMember])
    
    case site(Site)
    case sites([Site])

    case ecoDatum(EcoDatum)
    case ecoData([EcoDatum])
        
  }
  
  var state: [Key: Value] = [:]
  
}


