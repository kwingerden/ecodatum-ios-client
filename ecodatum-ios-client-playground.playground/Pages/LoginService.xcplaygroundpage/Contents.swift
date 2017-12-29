import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Networking {
  
  static let shared = Networking()
  
  let defaultSession: URLSession
  
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
  
}

class LoginService {

  let baseURL: URL

  enum Errors: Error {
    case base64EncodingError
  }
  
  struct LoginResponse: Decodable {
    let id: Int
    let token: String
    let userId: Int
  }
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func login(email: String,
             password: String) throws {
    
    guard !email.isEmpty,
      !password.isEmpty,
      let authorization = "\(email):\(password)"
      .data(using: .utf8)?
      .base64EncodedString() else {
      throw Errors.base64EncodingError
    }
    
    let url = baseURL.appendingPathComponent("login")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
    let task = Networking.shared.defaultSession.dataTask(with: request) {
      data, response, error in
      
      defer {
        PlaygroundPage.current.finishExecution()
      }
      
      guard let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          print("No data or statusCode not CREATED")
          return
      }
      
      let decoder = JSONDecoder()
      do {
        let post = try decoder.decode(LoginResponse.self, from: data)
        // decoded data is just the Post we created on json-server
        post
      } catch let decodeError as NSError {
        print("Decoder error: \(decodeError.localizedDescription)\n")
        return
      }
  
    }
    
    task.resume()
    
  }
  
}

try LoginService(baseURL: URL(string: "http://0.0.0.0:8080/api/v1/")!)
  .login(email: "admin@ecodatum.org", password: "password")

