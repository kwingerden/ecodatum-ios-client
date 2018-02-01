import Alamofire
import Foundation
import Hydra

protocol NetworkCall {
  
  associatedtype NetworkRequest
  associatedtype NetworkResponse
  func run(_ request: NetworkRequest) throws -> Promise<NetworkResponse>
  
}

class BaseNetworkCall {
  
  let url: URL
  
  let invalidationToken: InvalidationToken?
  
  init(url: URL,
       invalidationToken: InvalidationToken? = nil) {
    self.url = url
    self.invalidationToken = invalidationToken
  }
  
  func validate(url: URL) throws -> (String, String, Int) {
    guard let scheme = url.scheme,
      let host = url.host,
      let port = url.port else {
        throw NetworkError.invalidURL(url: url.absoluteString)
    }
    return (scheme, host, port)
  }
  
}

class BasicAuthUserCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    
    guard let headers = Request.basicAuthHeaders(
      email: request.email,
      password: request.password) else {
        throw NetworkError.authorizationHeaderEncoding
    }
    
    guard let (scheme, host, port) = try? validate(url: url) else {
      throw NetworkError.invalidURL(url: self.url.absoluteString)
    }
    
    let credential = URLCredential(
      user: request.email,
      password: request.password,
      persistence: .forSession)
    let protectionSpace = URLProtectionSpace(
      host: host,
      port: port,
      protocol: scheme,
      realm: host,
      authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
    URLCredentialStorage.shared.setDefaultCredential(credential, for: protectionSpace)
    
    let request = Alamofire.request(
      url,
      method: .post,
      encoding: JSONEncoding.default,
      headers: headers)
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<BasicAuthUserResponse>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(BasicAuthUserResponse.self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class CreateNewOrganizationUserCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: CreateNewOrganizationUserRequest) throws -> Promise<UserResponse> {
    
    let parameters = try JSONSerialization.jsonObject(
      with: try JSONEncoder().encode(request),
      options: [])
      as? [String: Any]
    
    let request = Alamofire.request(
      url,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: Request.defaultHeaders())
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<UserResponse>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(UserResponse.self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class GetOrganizationsByUserCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: GetOrganizationsByUserRequest)
    throws -> Promise<[OrganizationResponse]> {
    
    let request = Alamofire.request(
      url,
      method: .get,
      encoding: JSONEncoding.default,
      headers: Request.bearerTokenAuthHeaders(request.token))
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<[OrganizationResponse]>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(
                [OrganizationResponse].self,
                from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class GetUserCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: GetUserRequest) throws -> Promise<UserResponse> {
    
    let request = Alamofire.request(
      url,
      method: .get,
      encoding: JSONEncoding.default,
      headers: Request.bearerTokenAuthHeaders(request.token))
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<UserResponse>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(UserResponse.self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class CreateNewSiteCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: CreateNewSiteRequest) throws -> Promise<SiteResponse> {
    
    let parameters = try JSONSerialization.jsonObject(
      with: try JSONEncoder().encode(request),
      options: [])
      as? [String: Any]
    
    let request = Alamofire.request(
      url,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: Request.bearerTokenAuthHeaders(request.token))
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<SiteResponse>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          LOG.debug(response.debugDescription)
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode(SiteResponse.self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class GetSitesByOrganizationAndUserCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: GetSitesByOrganizationAndUserRequest)
    throws -> Promise<[SiteResponse]> {
    
    let request = Alamofire.request(
      url,
      method: .get,
      encoding: JSONEncoding.default,
      headers: Request.bearerTokenAuthHeaders(request.token))
    
    let debugDescription = request.debugDescription
    LOG.debug(debugDescription)
    
    return Promise<[SiteResponse]>(
      in: .userInitiated,
      token: invalidationToken) {
        
        resolve, reject, status in
        
        request.validate(statusCode: [200]).responseData {
          
          response in
          
          LOG.debug(response.debugDescription)
          
          if status.isCancelled {
            status.cancel()
            return
          }
          
          if let error = response.error {
            reject(error)
          } else if let data = response.data {
            do {
              let response = try JSONDecoder().decode([SiteResponse].self, from: data)
              resolve(response)
            } catch let error {
              reject(error)
            }
          } else {
            reject(NetworkError.unexpectedResponse)
          }
          
        }
    }
    
  }
  
}

class GetAbioticFactorsCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: GetAbioticFactorsRequest)
    throws -> Promise<[AbioticFactorResponse]> {
      
      let request = Alamofire.request(
        url,
        method: .get,
        encoding: JSONEncoding.default)
      
      let debugDescription = request.debugDescription
      LOG.debug(debugDescription)
      
      return Promise<[AbioticFactorResponse]>(
        in: .userInitiated,
        token: invalidationToken) {
          
          resolve, reject, status in
          
          request.validate(statusCode: [200]).responseData {
            
            response in
            
            LOG.debug(response.debugDescription)
            
            if status.isCancelled {
              status.cancel()
              return
            }
            
            if let error = response.error {
              reject(error)
            } else if let data = response.data {
              do {
                let response = try JSONDecoder().decode([AbioticFactorResponse].self, from: data)
                resolve(response)
              } catch let error {
                reject(error)
              }
            } else {
              reject(NetworkError.unexpectedResponse)
            }
            
          }
      }
  }
      
}

class GetMeasurementUnitsByAbioticFactorIdCall: BaseNetworkCall, NetworkCall {
  
  func run(_ request: GetMeasurementUnitsByAbioticFactorIdRequest)
    throws -> Promise<[MeasurementUnitResponse]> {
      
      let request = Alamofire.request(
        url,
        method: .get,
        encoding: JSONEncoding.default)
      
      let debugDescription = request.debugDescription
      LOG.debug(debugDescription)
      
      return Promise<[MeasurementUnitResponse]>(
        in: .userInitiated,
        token: invalidationToken) {
          
          resolve, reject, status in
          
          request.validate(statusCode: [200]).responseData {
            
            response in
            
            LOG.debug(response.debugDescription)
            
            if status.isCancelled {
              status.cancel()
              return
            }
            
            if let error = response.error {
              reject(error)
            } else if let data = response.data {
              do {
                let response = try JSONDecoder().decode([MeasurementUnitResponse].self, from: data)
                resolve(response)
              } catch let error {
                reject(error)
              }
            } else {
              reject(NetworkError.unexpectedResponse)
            }
            
          }
      }
  }
  
}








