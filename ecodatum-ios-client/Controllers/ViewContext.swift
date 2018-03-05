import Foundation

class ViewContext {
  
  enum Key {
    
    case abioticFactor
    case abioticFactors
    
    case organization
    case organizations
    case organizationMembers
    
    case measurement
    case measurements
    
    case measurementUnit
    case measurementUnits

    case photo
    case photos
    
    case primaryAbioticFactor
    case secondaryAbioticFactor

    case site
    case sites
    
    case survey
    case surveys
  
  }

  enum Value {
        
    case organization(Organization)
    case organizations([Organization])
    case organizationMembers([OrganizationMember])
    
    case measurement(Measurement)
    case measurements([Measurement])

    case site(Site)
    case sites([Site])
    
    case measurementUnit(MeasurementUnit)
    case measurementUnits([MeasurementUnit])

    case primaryAbioticFactor(MeasurementUnit.PrimaryAbioticFactor)
    case secondaryAbioticFactor(MeasurementUnit.SecondaryAbioticFactor)

    case photo(Photo)
    case photos([Photo])
    
    case survey(Survey)
    case surveys([Survey])
    
  }
  
  var state: [Key: Value] = [:]
  
}


