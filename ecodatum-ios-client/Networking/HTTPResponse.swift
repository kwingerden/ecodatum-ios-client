import Foundation

typealias HTTPResponseHandler<T> = (HTTPResponse<T>) -> Void

enum HTTPResponse<T> {
  
  case success(T)
  case error(Error)

}
