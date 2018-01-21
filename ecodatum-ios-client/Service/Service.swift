import Foundation
import Hydra

protocol Service {
  
  associatedtype ServiceRequest
  associatedtype ServiceResponse
  func run(_ serviceRequest: ServiceRequest) -> Promise<ServiceResponse>
  
}

