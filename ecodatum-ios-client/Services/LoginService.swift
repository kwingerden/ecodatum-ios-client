import Foundation

class LoginService {
  
  let baseURL: URL
  
  enum Errors: Error {
    case authenticationError
    case base64EncodingError
    case reponseDecodingError(String)
  }
  
  struct LoginRequest: Encodable {
    let email: String
    let password: String
  }
  
  struct UserToken: Decodable {
    let id: Int
    let token: String
    let userId: Int
  }
  
  enum LoginResponse {
    case success(UserToken)
    case failure(Errors)
  }
  
  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func login(request: LoginRequest,
             callback: @escaping (LoginResponse) -> Void) throws {
    
    guard !request.email.isEmpty,
      !request.password.isEmpty,
      let authorization = "\(request.email):\(request.password)"
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
      
      guard let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          callback(.failure(.authenticationError))
          return
      }
      
      do {
        let userToken = try JSONDecoder().decode(UserToken.self, from: data)
        callback(.success(userToken))
      } catch let error {
        callback(.failure(.reponseDecodingError(error.localizedDescription)))
        return
      }
      
    }
    
    task.resume()
    
  }
  
}
