import Foundation

class NetworkHelper {
  
  static func defaultNetworkManager() throws -> NetworkManager {
    return NetworkManager(baseURL: ECODATUM_BASE_V1_API_URL)
  }
  
}

