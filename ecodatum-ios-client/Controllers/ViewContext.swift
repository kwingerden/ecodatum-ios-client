import Foundation

class ViewContext {
  
  enum Key {
    
    case abioticFactor
    case abioticFactors
    
    case organization
    case organizations
    
    case measurementUnit
    case measurementUnits
    
    case site
    case sites
  
  }

  enum Value {
    
    case abioticFactor(AbioticFactor)
    case abioticFactors([AbioticFactor])
    
    case organization(Organization)
    case organizations([Organization])
    
    case measurementUnit(MeasurementUnit)
    case measurementUnits([MeasurementUnit])
    
    case site(Site)
    case sites([Site])
    
  }
  
  var state: [Key: Value] = [:]
  
}


