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

      let organizationResponses = try await(try self.networkManager.call(request))
      return organizationResponses.map {

        organizationResponse in

        return Organization(
          id: organizationResponse.id,
          code: organizationResponse.code,
          name: organizationResponse.name,
          description: organizationResponse.description,
          createdAt: organizationResponse.createdAt,
          updatedAt: organizationResponse.updatedAt)

      }
    }
  }

  func call(_ request: GetMembersByOrganizationAndUserRequest) throws -> Promise<[OrganizationMember]> {
    return async(in: .userInitiated) {

      status in

      let organizationMemberResponses = try await(try self.networkManager.call(request))

      return organizationMemberResponses.map {

        organizationMemberResponse in

        let user = User(
          id: organizationMemberResponse.user.id,
          fullName: organizationMemberResponse.user.fullName,
          email: organizationMemberResponse.user.email)
        let role = Role(
          id: organizationMemberResponse.role.id,
          name: organizationMemberResponse.role.name)

        return OrganizationMember(user: user, role: role)

      }
    }
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<User> {
    return async(in: .userInitiated) {
      status in
      let userResponse = try await(try self.networkManager.call(request))
      return User(
        id: userResponse.id,
        fullName: userResponse.fullName,
        email: userResponse.email)
    }
  }
  
  func call(_ request: NewOrUpdateSiteRequest) throws -> Promise<Site> {
    return async(in: .userInitiated) {
      status in
      let siteResponse = try await(try self.networkManager.call(request))
      return Site(
        id: siteResponse.id,
        name: siteResponse.name,
        description: siteResponse.description,
        latitude: siteResponse.latitude,
        longitude: siteResponse.longitude,
        altitude: siteResponse.altitude,
        horizontalAccuracy: siteResponse.horizontalAccuracy,
        verticalAccuracy: siteResponse.verticalAccuracy,
        organizationId: siteResponse.organizationId,
        userId: siteResponse.userId,
        createdAt: siteResponse.createdAt,
        updatedAt: siteResponse.updatedAt)
    }
  }
  
  func call(_ request: GetSitesByOrganizationAndUserRequest) throws -> Promise<[Site]> {
    return async(in: .userInitiated) {

      status in

      let siteResponses = try await(try self.networkManager.call(request))
      return siteResponses.map {
        siteResponse in
        return Site(
          id: siteResponse.id,
          name: siteResponse.name,
          description: siteResponse.description,
          latitude: siteResponse.latitude,
          longitude: siteResponse.longitude,
          altitude: siteResponse.altitude,
          horizontalAccuracy: siteResponse.horizontalAccuracy,
          verticalAccuracy: siteResponse.verticalAccuracy,
          organizationId: siteResponse.organizationId,
          userId: siteResponse.userId,
          createdAt: siteResponse.createdAt,
          updatedAt: siteResponse.updatedAt)

      }
    }
  }
  
  func call(_ request: DeleteSiteByIdRequest) throws -> Promise<HttpOKResponse> {
    return try networkManager.call(request)
  }

  /*
  func call(_ request: NewOrUpdateEcoDataRequest) throws -> Promise<EcoData> {
    return async(in: .userInitiated) {
      status in
      let siteResponse = try await(try self.networkManager.call(request))
      return Site(
        id: siteResponse.id,
        name: siteResponse.name,
        description: siteResponse.description,
        latitude: siteResponse.latitude,
        longitude: siteResponse.longitude,
        altitude: siteResponse.altitude,
        horizontalAccuracy: siteResponse.horizontalAccuracy,
        verticalAccuracy: siteResponse.verticalAccuracy,
        organizationId: siteResponse.organizationId,
        userId: siteResponse.userId,
        createdAt: siteResponse.createdAt,
        updatedAt: siteResponse.updatedAt)
    }
  }
  */

}
