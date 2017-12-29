import Foundation

class Networking {
  
  static let shared = Networking()
  
  private let defaultSession: URLSession
  
  private init() {
    
    let cache = URLCache(
      memoryCapacity: 1_000_000,
      diskCapacity: 50_000_000,
      diskPath: nil)
    
    let defaultConfiguration = URLSessionConfiguration.default
    defaultConfiguration.allowsCellularAccess = true
    defaultConfiguration.multipathServiceType = .handover
    defaultConfiguration.urlCache = cache
    defaultConfiguration.waitsForConnectivity = true
    
    defaultSession = URLSession(configuration: defaultConfiguration)
  
  }
  
  func login(email: String, password: String) {
    print(defaultSession.configuration.allowsCellularAccess)
  }
  
}
