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

  func call(_ request: NewOrUpdateEcoDatumRequest) throws -> Promise<EcoDatum> {
    return async(in: .userInitiated) {
      status in
      let response = try await(try self.networkManager.call(request))
      return ServiceManager.fromResponse(response)
    }
  }

  static func toRequest(
    token: AuthenticationToken,
    ecoDatumId: Identifier?,
    siteId: Identifier,
    ecoDatum: EcoDatum) -> NewOrUpdateEcoDatumRequest {

    guard let ecoFactor = ecoDatum.ecoFactor else {
      fatalError()
    }

    var abioticData: AbioticData?
    var bioticData: BioticData?

    switch ecoDatum.ecoFactor {

    case .Abiotic?:

      guard let abioticFactor = ecoDatum.abioticFactor?.rawValue,
            let abioticEcoData = ecoDatum.abioticEcoData,
            let dataUnit = abioticEcoData.dataUnit,
            let dataValue = abioticEcoData.dataValue else {
        fatalError()
      }

      var dataType: String = ""
      switch abioticEcoData.dataType {
      case .Air(let airDataType)?: dataType = airDataType.rawValue
      case .Soil(let soilDataType)?: dataType = soilDataType.rawValue
      case .Water(let waterDataType)?: dataType = waterDataType.rawValue
      default: fatalError()
      }

      abioticData = AbioticData(
        abioticFactor: abioticFactor,
        dataType: dataType,
        dataUnit: dataUnit.rawValue,
        dataValue: dataValue.description)

    case .Biotic?: break
      /*
      bioticData = BioticData(
        image: <#T##Base64Encoded##ecodatum_ios_client.Base64Encoded#>,
        notes: <#T##Base64Encoded##ecodatum_ios_client.Base64Encoded#>)
        */

    default: fatalError()

    }

    return NewOrUpdateEcoDatumRequest(
      token: token,
      id: ecoDatumId,
      siteId: siteId,
      date: ecoDatum.date,
      time: ecoDatum.time,
      ecoFactor: ecoFactor.rawValue,
      abioticData: abioticData,
      bioticData: bioticData)

  }

  static func fromResponse(_ response: EcoDatumResponse) -> EcoDatum {

    var ecoFactor: EcoFactor?
    var data: EcoDatum.AbioticOrBioticData?

    switch EcoFactor(rawValue: response.ecoFactor) {

    case .Abiotic?:
      ecoFactor = .Abiotic

      guard let abioticData = response.abioticData,
            let abioticFactor = AbioticFactor(rawValue: abioticData.abioticFactor),
            let dataUnit = AbioticDataUnitChoice(rawValue: abioticData.dataUnit) else {
        fatalError()
      }

      var dataType: AbioticDataTypeChoice?
      switch abioticFactor {

      case .Air:
        guard let airDataType = AirDataType(rawValue: abioticData.dataValue) else {
          fatalError()
        }
        dataType = AbioticDataTypeChoice.Air(airDataType)

      case .Soil:
        guard let soilDataType = SoilDataType(rawValue: abioticData.dataValue) else {
          fatalError()
        }
        dataType = AbioticDataTypeChoice.Soil(soilDataType)

      case .Water:
        guard let waterDataType = WaterDataType(rawValue: abioticData.dataValue) else {
          fatalError()
        }
        dataType = AbioticDataTypeChoice.Water(waterDataType)

      }

      let abioticEcoData = AbioticEcoData(
        abioticFactor: abioticFactor,
        dataType: dataType,
        dataUnit: dataUnit,
        dataValue: nil)

      data = EcoDatum.AbioticOrBioticData.Abiotic(abioticEcoData)

    case .Biotic?:
      ecoFactor = .Biotic
      let bioticEcoData = BioticEcoData()
      data = EcoDatum.AbioticOrBioticData.Biotic(bioticEcoData)

    default: fatalError()

    }

    return EcoDatum(
      id: response.id,
      date: response.date,
      time: response.time,
      ecoFactor: ecoFactor,
      data: data)

  }

}
