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
  
  func setImage(_ imageView: UIImageView, imageId: Identifier) {
    imageView.af_setImage(withURL: networkManager.makeImageURL(imageId))
  }
  
  func setAuthenticatedUser(_ user: AuthenticatedUserRecord) throws {
    
    return try databaseManager.write {
      db in
      let count = try AuthenticatedUserRecord.fetchCount(db)
      if count == 0 {
        try user.save(db)
      } else {
        throw DatabaseError.authenticatedUserAlreadyExists
      }
      return .commit
    }
    
  }
  
  func getAuthenticatedUser() throws -> AuthenticatedUserRecord? {
    
    return try databaseManager.read {
      db in
      try AuthenticatedUserRecord.fetchOne(db)
    }
    
  }
  
  func deleteAuthenticatedUser() throws {
    
    return try databaseManager.write {
      db in
      try AuthenticatedUserRecord.deleteAll(db)
      return .commit
    }
    
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
  
  func call(_ request: GetOrganizationsByUserRequest) throws -> Promise<[OrganizationResponse]> {
    return try networkManager.call(request)
  }

  func call(_ request: GetMembersByOrganizationAndUserRequest) throws -> Promise<[OrganizationMemberResponse]> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<UserResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: NewOrUpdateSiteRequest) throws -> Promise<SiteResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetSitesByOrganizationAndUserRequest) throws -> Promise<[SiteResponse]> {
    return try networkManager.call(request)
  }
  
  func call(_ request: DeleteSiteByIdRequest) throws -> Promise<HttpOKResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: NewOrUpdateSurveyRequest) throws -> Promise<SurveyResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetSurveysBySiteAndUserRequest) throws -> Promise<[SurveyResponse]> {
    return try networkManager.call(request)
  }

  func call(_ request: DeleteSurveyByIdRequest) throws -> Promise<HttpOKResponse> {
    return try networkManager.call(request)
  }

  func call(_ request: GetMeasurementUnitsRequest) throws -> Promise<[MeasurementUnitResponse]> {
    return try networkManager.call(request)
  }
  
  func call(_ request: AddNewMeasurementRequest) throws -> Promise<MeasurementResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetMeasurementsBySurveyRequest) throws -> Promise<[MeasurementResponse]> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetPhotosBySurveyRequest) throws -> Promise<[PhotoResponse]> {
    return try networkManager.call(request)
  }

  func call(_ request: NewOrUpdatePhotoRequest) throws -> Promise<PhotoResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: DeletePhotoByIdRequest) throws -> Promise<HttpOKResponse> {
    return try networkManager.call(request)
  }
  
}
