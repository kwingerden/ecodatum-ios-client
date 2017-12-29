import Foundation

class URLHelper {
  
  private init() {}
  
  enum Errors: Error {
    case invalidURL
  }
  
  static func makeURL(fromString: String) throws -> URL {
    guard let url = URL(string: fromString) else {
      throw Errors.invalidURL
    }
    return url
  }
  
}
