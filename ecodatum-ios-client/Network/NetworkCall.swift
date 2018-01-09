import Foundation
import Hydra

protocol NetworkCall {
  
  associatedtype NetworkData
  func run() -> Promise<NetworkData>
  
}
