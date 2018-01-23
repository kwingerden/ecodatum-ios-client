import Foundation
import Hydra

class ServiceManager {
  
  let databaseManager: DatabaseManager
  
  let networkManager: NetworkManager
  
  init(databaseManager: DatabaseManager,
       networkManager: NetworkManager) {
    self.databaseManager = databaseManager
    self.networkManager = networkManager
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
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<CreateNewOrganizationUserResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetOrganizationsByUserIdRequest) throws -> Promise<[GetOrganizationsByUserIdResponse]> {
    return try networkManager.call(request)
  }
  
  func call(_ request: GetUserByIdRequest) throws -> Promise<GetUserByIdResponse> {
    return try networkManager.call(request)
  }
  
  func call(_ request: CreateNewSiteRequest) throws -> Promise<CreateNewSiteResponse> {
    return try networkManager.call(request)
  }
  
}
