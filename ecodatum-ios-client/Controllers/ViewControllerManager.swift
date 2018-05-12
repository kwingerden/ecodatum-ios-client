import Alamofire
import Foundation
import Hydra
import SwiftValidator
import UIKit

typealias CompletionBlock = () -> Void
typealias PreAsyncBlock = () -> Void
typealias PostAsyncBlock = () -> Void

class ViewControllerManager: EcoDatumHandler, SiteHandler {
  
  let viewController: UIViewController
  
  let storyboardSegue: UIStoryboardSegue?
  
  let viewContext: ViewContext
  
  let serviceManager: ServiceManager
  
  var authenticatedUser: AuthenticatedUser?
  
  var organization: Organization? {
    get {
      guard let value = viewContext.state[.organization] else {
        return nil
      }
      if case let ViewContext.Value.organization(organization) = value {
        return organization
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.organization] = ViewContext.Value.organization(newValue)
      } else {
        viewContext.state[.organization] = nil
      }
    }
  }

  var organizationMembers: [OrganizationMember] {
    get {
      guard let value = viewContext.state[.organizationMembers] else {
        return []
      }
      if case let ViewContext.Value.organizationMembers(organizationMembers) = value {
        return organizationMembers
      } else {
        return []
      }
    }
    set {
      viewContext.state[.organizationMembers] = ViewContext.Value.organizationMembers(newValue)
    }
  }
  
  var organizations: [Organization] {
    get {
      guard let value = viewContext.state[.organizations] else {
        return []
      }
      if case let ViewContext.Value.organizations(organizations) = value {
        return organizations.sorted {
          $0.createdAt < $1.createdAt
        }
      } else {
        return []
      }
    }
    set {
      viewContext.state[.organizations] = ViewContext.Value.organizations(newValue)
    }
  }
  
  var site: Site? {
    get {
      guard let value = viewContext.state[.site] else {
        return nil
      }
      if case let ViewContext.Value.site(site) = value {
        return site
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.site] = ViewContext.Value.site(newValue)
      } else {
        viewContext.state[.site] = nil
      }
    }
  }
  
  var sites: [Site] {
    get {
      guard let value = viewContext.state[.sites] else {
        return []
      }
      if case let ViewContext.Value.sites(sites) = value {
        return sites.sorted {
          $0.name < $1.name
        }
      } else {
        return []
      }
    }
    set {
      viewContext.state[.sites] = ViewContext.Value.sites(newValue)
    }
  }
  
  var siteHandler: SiteHandler {
    var newSiteHandler: SiteHandler = self
    if let siteHandler = storyboardSegue?.source as? SiteHandler {
      newSiteHandler = siteHandler
    }
    return newSiteHandler
  }

  var siteId: Identifier? {
    return ViewControllerSegue.newSite == viewControllerSegue ? nil : site?.id
  }

  var ecoDatum: EcoDatum? {
    get {
      guard let value = viewContext.state[.ecoDatum] else {
        return nil
      }
      if case let ViewContext.Value.ecoDatum(ecoDatum) = value {
        return ecoDatum
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.ecoDatum] = ViewContext.Value.ecoDatum(newValue)
      } else {
        viewContext.state[.ecoDatum] = nil
      }
    }
  }

  var ecoData: [EcoDatum] {
    get {
      guard let value = viewContext.state[.ecoData] else {
        return []
      }
      if case let ViewContext.Value.ecoData(ecoData) = value {
        return ecoData.sorted {
          $0.date < $1.date
        }
      } else {
        return []
      }
    }
    set {
      viewContext.state[.ecoData] = ViewContext.Value.ecoData(newValue)
    }
  }

  var ecoDatumHandler: EcoDatumHandler {
    var newEcoDataHandler: EcoDatumHandler = self
    if let ecoDataHandler = storyboardSegue?.source as? EcoDatumHandler {
      newEcoDataHandler = ecoDataHandler
    }
    return newEcoDataHandler
  }

  var ecoDatumId: Identifier? {
    return ViewControllerSegue.newEcoDatum == viewControllerSegue ? nil : ecoDatum?.id
  }
  
  var viewControllerSegue: ViewControllerSegue? {
    if let identifier = storyboardSegue?.identifier,
      let viewControllerSegue = ViewControllerSegue(rawValue: identifier) {
      return viewControllerSegue
    } else {
      return nil
    }
  }

  var formSheetSegue: FormSheetSegue? {
    return storyboardSegue as? FormSheetSegue
  }

  var isFormSheetSegue: Bool {
    return formSheetSegue != nil
  }
  
  init(viewController: UIViewController,
       storyboardSegue: UIStoryboardSegue? = nil,
       viewContext: ViewContext,
       serviceManager: ServiceManager,
       authenticatedUser: AuthenticatedUser? = nil) {
    self.viewController = viewController
    self.storyboardSegue = storyboardSegue
    self.viewContext = viewContext
    self.serviceManager = serviceManager
    self.authenticatedUser = authenticatedUser
  }

  convenience init(newViewController: UIViewController,
                   storyboardSegue: UIStoryboardSegue? = nil,
                   viewControllerManager: ViewControllerManager) {
    self.init(viewController: newViewController,
              storyboardSegue: storyboardSegue,
              viewContext: viewControllerManager.viewContext,
              serviceManager: viewControllerManager.serviceManager,
              authenticatedUser: viewControllerManager.authenticatedUser)
  }
  
  func performSegue(from: UIViewController? = nil,
                    to: ViewControllerSegue,
                    sender: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(viewController) => \(to)")
    
    (from ?? viewController).performSegue(
      withIdentifier: to.rawValue,
      sender: sender)
    
  }
  
  func main() throws {
    
    if let authenticatedUser = authenticatedUser {
      
      try serviceManager.call(
        GetOrganizationsByUserRequest(
          token: authenticatedUser.token))
        .then(in: .main, handleOrganizations)
        .catch(in: .main, handleError)
      
    } else {
      
      performSegue(to: .welcome)
      
    }
    
  }
  
  func login(email: String,
             password: String,
             preAsyncBlock: PreAsyncBlock? = nil,
             postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        BasicAuthUserRequest(
          email: email,
          password: password))
        .then(in: .userInitiated, handleBasicAuthUser)
        .then(in: .userInteractive) {
          authenticatedUser in
          return try self.serviceManager.call(
            GetOrganizationsByUserRequest(
              token: authenticatedUser.token))
        }
        .then(in: .main, handleOrganizations)
        .catch(in: .main) {
          error in
          if self.isUnauthorizedError(error) {
            self.showErrorMessage(
              "Login Failure",
              "Invalid username and/or password.")
          } else {
            self.handleError(error)
          }
        }
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func logout(_ segueSourceViewController: UIViewController? = nil) {
    
    do {
      
      try serviceManager.call(
        LogoutRequest(
          userId: authenticatedUser!.userId,
          token: authenticatedUser!.token))
        .catch(in: .main, handleError)
        .always(in: .main) {
          self.doLogout(segueSourceViewController)
      }
      
    } catch let error {
      
      handleError(error)
    
    }
    
  }
  
  func createNewAccount(
    organizationCode: String,
    fullName: String,
    email: String,
    password: String,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        CreateNewOrganizationUserRequest(
          organizationCode: organizationCode,
          fullName: fullName,
          email: email,
          password: password))
        .then(in: .userInitiated) {
          _ in
          try self.handleCreateNewAccount(
            email: email,
            password: password)
        }.then(in: .userInitiated, handleBasicAuthUser)
        .then(in: .userInitiated) {
          authenticatedUser in
          return try self.serviceManager.call(
            GetOrganizationsByUserRequest(
              token: authenticatedUser.token))
        }
        .then(in: .main, handleOrganizations)
        .catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func showOrganization(_ organization: Organization) {

    self.organization = organization
    getOrganizationMembers {
      self.performSegue(to: .topNavigation)
    }
    
  }
  
  func newOrUpdateSite(
    name: String,
    description: String? = nil,
    latitude: Double,
    longitude: Double,
    altitude: Double? = nil,
    horizontalAccuracy: Double? = nil,
    verticalAccuracy: Double? = nil,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let organizationId = organization?.id else {
      handleError(ViewControllerError.noOrganizationIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        NewOrUpdateSiteRequest(
          token: token,
          id: siteId,
          organizationId: organizationId,
          name: name,
          description: description,
          latitude: latitude,
          longitude: longitude,
          altitude: altitude,
          horizontalAccuracy: horizontalAccuracy,
          verticalAccuracy: verticalAccuracy))
        .then(in: .main) {
          site in
          if self.siteId == nil {
            self.siteHandler.handleNewSite(site: site)
          } else {
            self.siteHandler.handleUpdatedSite(site: site)
          }
          if let completionBlock = completionBlock {
            completionBlock()
          }
        }.catch(in: .main) {
          error in
          if self.isConflictError(error) {
            self.handleError(
              ViewControllerError.siteNameConflict(name: name))
          } else {
            self.handleError(error)
          }
        }.always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func chooseExistingSite(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let organizationId = organization?.id else {
      handleError(ViewControllerError.noOrganizationIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetSitesByOrganizationAndUserRequest(
          token: token,
          organizationId: organizationId))
        .then(in: .main, handleSites)
        .catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }
  
  func showSite(_ site: Site, segue: ViewControllerSegue) {
    
    self.site = site
    performSegue(to: segue)
    
  }
  
  func deleteSite(
    site: Site,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        DeleteSiteByIdRequest(
          token: token,
          siteId: site.id))
        .then(in: .main) {
          _ in
          self.siteHandler.handleDeletedSite(site: site)
        }.catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    
  }

  func newOrUpdateEcoDatum(
    ecoDatum: EcoDatum,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil) {

    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }

    do {

      let request = NewOrUpdateEcoDatumRequest(
        token: token,
        id: ecoDatum.id,
        json: ecoDatum.json,
        siteId: ecoDatum.siteId,
        userId: ecoDatum.userId)
      try serviceManager.call(request)
        .then(in: .main) {
          ecoData in
          if self.ecoDatumId == nil {
            self.ecoDatumHandler.handleNewEcoDatum(ecoDatum: ecoData)
          } else {
            self.ecoDatumHandler.handleUpdatedEcoDatum(ecoDatum: ecoData)
          }
          if let completionBlock = completionBlock {
            completionBlock()
          }
        }.catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
        }

    } catch let error {

      handleError(error)

    }

  }

  func showErrorMessage(_ title: String,
                        _ message: String,
                        handler: ((UIAlertAction) -> Void)? = nil) {

    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    alertController.addAction(
      UIAlertAction(
        title: "OK",
        style: UIAlertActionStyle.default,
        handler: handler))

    viewController.present(
      alertController,
      animated: true,
      completion: nil)

  }

  func getOrganizationMembers(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil) {

    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    guard let organizationId = organization?.id else {
      handleError(ViewControllerError.noOrganizationIdentifier)
      return
    }

    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }

    do {

      try serviceManager.call(
          GetMembersByOrganizationAndUserRequest(
            token: token,
            organizationId: organizationId))
        .then(in: .main) {
          organizationMembers in
          self.organizationMembers = organizationMembers
          if let completionBlock = completionBlock {
            completionBlock()
          }
        }.catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
        }

    } catch let error {

      handleError(error)

    }

  }

  func handleNewSite(site: Site) {

    self.site = site
    sites.append(site)
    performSegue(to: .siteNavigationChoice)
  
  }
  
  func handleUpdatedSite(site: Site) {

    self.site = site
    if let index = sites.index(where: { $0.id == site.id }) {
      sites.replaceSubrange(index...index, with: [site])
    }
    
  }

  func handleDeletedSite(site: Site) {

    if let index = sites.index(where: { $0.id == site.id }) {
      sites.remove(at: index)
    }

  }

  func handleSites(_ sites: [Site]) {

    self.sites = sites

    if sites.isEmpty {

      showErrorMessage(
        "No Existing Sites",
        ViewControllerError.noOrganizationSites(
          name: organization!.name).localizedDescription)
      
    } else {

      performSegue(to: .siteChoice)
      
    }
    
  }

  func handleNewEcoDatum(ecoDatum: EcoDatum) {
    self.ecoDatum = ecoDatum
    performSegue(to: .siteNavigationChoice)
  }

  func handleUpdatedEcoDatum(ecoDatum: EcoDatum) {

  }

  func handleDeletedEcoDatum(ecoDatum: EcoDatum) {

  }

  private func isResponseStatus(_ error: Error, status: Int) -> Bool {
    if let afError = error as? AFError,
      afError.responseCode == status {
      return true
    } else {
      return false
    }
  }
  
  private func isUnauthorizedError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 401)
  }
  
  private func isConflictError(_ error: Error) -> Bool {
    return isResponseStatus(error, status: 409)
  }
  
  private func handleError(_ error: Error) {
    
    LOG.error(error.localizedDescription)
    
    switch error {
      
    case AFError.responseValidationFailed(let reason):
      
      switch reason {
        
      case .unacceptableStatusCode(let code):
        
        switch code {
          
        case 401: // Unauthorized
          showErrorMessage(
            "Unauthorized Access",
            error.localizedDescription) {
              _ in
              self.doLogout()
          }
          
        default:
          showErrorMessage("Unexpected Error", error.localizedDescription)
          
        }
        
      default:
        showErrorMessage("Unexpected Error", error.localizedDescription)
        
      }
      
    case ViewControllerError.noUserOrganizations:
      showErrorMessage("No Organizations", error.localizedDescription)
      doLogout()
      
    case ViewControllerError.siteNameConflict:
      showErrorMessage("Site Already Exists", error.localizedDescription)
      
    default:
      showErrorMessage("Unexpected Error", error.localizedDescription)
      
    }
    
  }

  private func handleOrganizations(
    _ organizations: [Organization]) throws {

    if organizations.count == 1 {

      self.organization = organizations[0]
      self.organizations = organizations
      performSegue(to: .topNavigation)

    } else if organizations.count > 1 {

      self.organizations = organizations
      performSegue(to: .organizationChoice)

    } else {

      throw ViewControllerError.noUserOrganizations

    }

  }

  private func handleBasicAuthUser(
    _ basicAuthUserResponse: BasicAuthUserResponse)
    -> Promise<AuthenticatedUser> {
      
      return async(in: .userInitiated) {
        
        status in
        
        let user = try await(
          try self.serviceManager.call(
            GetUserRequest(
              userId: basicAuthUserResponse.userId,
              token: basicAuthUserResponse.token)))
        
        self.authenticatedUser = AuthenticatedUser(
          userId: user.id,
          token: basicAuthUserResponse.token,
          fullName: user.fullName,
          email: user.email,
          isRootUser: basicAuthUserResponse.isRootUser)

        return self.authenticatedUser!
        
      }
      
  }
  
  private func handleCreateNewAccount(
    email: String,
    password: String)
    throws -> Promise<BasicAuthUserResponse> {
      
      return try serviceManager.call(
        BasicAuthUserRequest(
          email: email,
          password: password))
      
  }
  
  private func segueToMainViewController(
    _ segueSourceViewController: UIViewController? = nil) {

    if let segueSourceViewController = segueSourceViewController {
      
      performSegue(from: segueSourceViewController, to: .main)
    
    } else if let _ = viewController as? MainViewController {
    
      performSegue(to: .welcome)
      
    } else {
      
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let mainViewController = mainStoryboard.instantiateViewController(
        withIdentifier: "MainViewController")
      mainViewController.modalTransitionStyle = .flipHorizontal
      viewController.present(mainViewController, animated: true, completion: nil)
    
    }
   
  }
  
  private func doLogout(_ segueSourceViewController: UIViewController? = nil) {
    segueToMainViewController(segueSourceViewController)
  }
  
  
}


