import Foundation

class ViewContext {
  
  enum Key {
    
    case organization
    case organizations
    case organizationMembers
    
    case site
    case sites

    case ecoData
    case ecoDatas
    
  }

  enum Value {
    
    case organization(Organization)
    case organizations([Organization])
    case organizationMembers([OrganizationMember])
    
    case site(Site)
    case sites([Site])

    case ecoData(EcoData)
    case ecoDatas([EcoData])
        
  }
  
  var state: [Key: Value] = [:]
  
}


