import Foundation

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
