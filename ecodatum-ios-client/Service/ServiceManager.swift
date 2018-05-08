import Alamofire
import AlamofireImage
import Foundation
import Hydra
import UIKit

class ServiceManager {
  
  let databaseManager: DatabaseManager
  
  let networkManager: NetworkManager
  
  init(databaseManager: DatabaseManager,
       networkManager: NetworkManager) {
    self.databaseManager = databaseManager
    self.networkManager = networkManager
  }
  
  func call(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: LogoutRequest) throws -> Promise<LogoutResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<UserResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetOrganizationsByUserRequest) throws -> Promise<[Organization]> {
    return async(in: .userInitiated) {
      status in
      let response = try await(try self.networkManager.call(request))
      return response.map {
        response in
        return Organization(
          id: response.id,
          code: response.code,
          name: response.name,
          description: response.description,
          createdAt: response.createdAt,
          updatedAt: response.updatedAt)
      }
    }
  }

  func call(_ request: GetMembersByOrganizationAndUserRequest) throws -> Promise<[OrganizationMember]> {
    return async(in: .userInitiated) {
      status in
      let responses = try await(try self.networkManager.call(request))
      return responses.map {
        response in
        let user = User(
          id: response.user.id,
          fullName: response.user.fullName,
          email: response.user.email)
        let role = Role(
          id: response.role.id,
          name: response.role.name)
        return OrganizationMember(user: user, role: role)
      }
    }
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<User> {
    return async(in: .userInitiated) {
      status in
      let response = try await(try self.networkManager.call(request))
      return User(
        id: response.id,
        fullName: response.fullName,
        email: response.email)
    }
  }
  
  func call(_ request: NewOrUpdateSiteRequest) throws -> Promise<Site> {
    return async(in: .userInitiated) {
      status in
      let response = try await(try self.networkManager.call(request))
      return Site(
        id: response.id,
        name: response.name,
        description: response.description,
        latitude: response.latitude,
        longitude: response.longitude,
        altitude: response.altitude,
        horizontalAccuracy: response.horizontalAccuracy,
        verticalAccuracy: response.verticalAccuracy,
        organizationId: response.organizationId,
        userId: response.userId,
        createdAt: response.createdAt,
        updatedAt: response.updatedAt)
    }
  }
  
  func call(_ request: GetSitesByOrganizationAndUserRequest) throws -> Promise<[Site]> {
    return async(in: .userInitiated) {
      status in
      let responses = try await(try self.networkManager.call(request))
      return responses.map {
        response in
        return Site(
          id: response.id,
          name: response.name,
          description: response.description,
          latitude: response.latitude,
          longitude: response.longitude,
          altitude: response.altitude,
          horizontalAccuracy: response.horizontalAccuracy,
          verticalAccuracy: response.verticalAccuracy,
          organizationId: response.organizationId,
          userId: response.userId,
          createdAt: response.createdAt,
          updatedAt: response.updatedAt)
      }
    }
  }
  
  func call(_ request: DeleteSiteByIdRequest) throws -> Promise<HttpOKResponse> {
    return try networkManager.call(request)
  }

  func call(_ request: NewOrUpdateEcoDataRequest) throws -> Promise<EcoData> {
    return async(in: .userInitiated) {
      status in
      let response = try await(try self.networkManager.call(request))
      return response.ecoData
    }
  }

}
