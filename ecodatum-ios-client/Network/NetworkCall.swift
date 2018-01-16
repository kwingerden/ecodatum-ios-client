import Foundation
import Hydra

protocol NetworkCall {
  
  associatedtype NetworkRequest
  associatedtype NetworkResponse
  func run(_ request: NetworkRequest) throws -> Promise<NetworkResponse>
  
}
