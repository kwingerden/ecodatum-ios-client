import Alamofire
import Foundation
import Hydra
import SwiftValidator
import UIKit

typealias AbioticFactor = AbioticFactorResponse
typealias AuthenticatedUser = AuthenticatedUserRecord
typealias Measurement = MeasurementResponse
typealias MeasurementUnit = MeasurementUnitResponse
typealias Organization = OrganizationResponse
typealias Site = SiteResponse
typealias Survey = SurveyResponse

typealias PreAsyncBlock = () -> Void
typealias PostAsyncBlock = () -> Void

class ViewControllerManager {
  
  private let viewController: UIViewController
  
  private let storyboardSegue: UIStoryboardSegue?
  
  private let viewContext: ViewContext
  
  private let serviceManager: ServiceManager
  
  lazy var authenticatedUser: AuthenticatedUser? = {
    do {
      return try serviceManager.getAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
      return nil
    }
  }()
  
  var abioticFactor: AbioticFactor? {
    guard let value = viewContext.state[.abioticFactor] else { return nil }
    if case let ViewContext.Value.abioticFactor(abioticFactor) = value {
      return abioticFactor
    } else {
      return nil
    }
  }
  
  var abioticFactors: [AbioticFactor] {
    guard let value = viewContext.state[.abioticFactors] else { return [] }
    if case let ViewContext.Value.abioticFactors(abioticFactors) = value {
      return abioticFactors
    } else {
      return []
    }
  }
  
  var organization: Organization? {
    guard let value = viewContext.state[.organization] else { return nil }
    if case let ViewContext.Value.organization(organization) = value {
      return organization
    } else {
      return nil
    }
  }
  
  var measurementUnit: MeasurementUnit? {
    guard let value = viewContext.state[.measurementUnit] else { return nil }
    if case let ViewContext.Value.measurementUnit(measurementUnit) = value {
      return measurementUnit
    } else {
      return nil
    }
  }
  
  var measurementUnits: [MeasurementUnit] {
    guard let value = viewContext.state[.measurementUnits] else { return [] }
    if case let ViewContext.Value.measurementUnits(measurementUnits) = value {
      return measurementUnits
    } else {
      return []
    }
  }
  
  var organizations: [Organization] {
    guard let value = viewContext.state[.organizations] else { return [] }
    if case let ViewContext.Value.organizations(organizations) = value {
      return organizations
    } else {
      return []
    }
  }
  
  var site: Site? {
    guard let value = viewContext.state[.site] else { return nil }
    if case let ViewContext.Value.site(site) = value {
      return site
    } else {
      return nil
    }
  }
  
  var sites: [Site] {
    guard let value = viewContext.state[.sites] else { return [] }
    if case let ViewContext.Value.sites(sites) = value {
      return sites
    } else {
      return []
    }
  }
  
  var survey: Survey? {
    guard let value = viewContext.state[.survey] else { return nil }
    if case let ViewContext.Value.survey(survey) = value {
      return survey
    } else {
      return nil
    }
  }
  
  var surveys: [Survey] {
    guard let value = viewContext.state[.surveys] else { return [] }
    if case let ViewContext.Value.surveys(surveys) = value {
      return surveys
    } else {
      return []
    }
  }
  
  var measurement: Measurement? {
    guard let value = viewContext.state[.measurement] else { return nil }
    if case let ViewContext.Value.measurement(measurement) = value {
      return measurement
    } else {
      return nil
    }
  }
  
  var measurements: [Measurement] {
    guard let value = viewContext.state[.measurements] else { return [] }
    if case let ViewContext.Value.measurements(measurements) = value {
      return measurements
    } else {
      return []
    }
  }
  
  init(viewController: UIViewController,
       storyboardSegue: UIStoryboardSegue? = nil,
       viewContext: ViewContext,
       serviceManager: ServiceManager) {
    self.viewController = viewController
    self.storyboardSegue = storyboardSegue
    self.viewContext = viewContext
    self.serviceManager = serviceManager
  }
  
  convenience init(newViewController: UIViewController,
                   storyboardSegue: UIStoryboardSegue? = nil,
                   viewControllerManager: ViewControllerManager) {
    self.init(viewController: newViewController,
              storyboardSegue: storyboardSegue,
              viewContext: viewControllerManager.viewContext,
              serviceManager: viewControllerManager.serviceManager)
  }
  
  func performSegue(from: UIViewController? = nil,
                    to: ViewController,
                    sender: Any? = nil) {
    
    LOG.debug("ViewControllerManager.performSegue: \(viewController) => \(to)")
    
    (from ?? viewController).performSegue(
      withIdentifier: to.rawValue,
      sender: sender)
    
  }
  
  func main() {
    
    if let authenticatedUser = authenticatedUser {
      
      getUserOrganizations(authenticatedUser)
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
        .then(in: .userInteractive, getUserOrganizations)
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
        .then(in: .userInitiated, getUserOrganizations)
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
    
    viewContext.state[.organization] = ViewContext.Value.organization(organization)
    performSegue(to: .topNavigation)
    
  }
  
  func createNewSite(
    name: String,
    description: String? = nil,
    latitude: Double,
    longitude: Double,
    altitude: Double? = nil,
    horizontalAccuracy: Double? = nil,
    verticalAccuracy: Double? = nil,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    newSiteHandler: @escaping (Site) -> Void) {
    
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
        CreateNewSiteRequest(
          token: token,
          name: name,
          description: description,
          latitude: latitude,
          longitude: longitude,
          altitude: altitude,
          horizontalAccuracy: horizontalAccuracy,
          verticalAccuracy: verticalAccuracy,
          organizationId: organizationId))
        .then(in: .main, newSiteHandler)
        .catch(in: .main) {
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
  
  func showSite(_ site: Site) {
    
    viewContext.state[.site] = ViewContext.Value.site(site)
    performSegue(to: .siteNavigationChoice)
    
  }
  
  func startNewSurvey(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let siteId = site?.id else {
      handleError(ViewControllerError.noSiteIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        StartNewSurveyRequest(
          token: token,
          siteId: siteId))
        .then(in: .main, handleNewSurvey)
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
  
  func chooseExistingSurvey(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let siteId = site?.id else {
      handleError(ViewControllerError.noSiteIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetSurveysBySiteAndUserRequest(
          token: token,
          siteId: siteId))
        .then(in: .main, handleSurveys)
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
  
  func showSurvey(_ survey: Survey) {
    
    viewContext.state[.survey] = ViewContext.Value.survey(survey)
    performSegue(to: .surveyNavigationChoice)
    
  }
  
  func getAbioticFactors(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetAbioticFactorsRequest())
        .then(in: .main, handleAbioticFactors)
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
  
  func showAbioticFactor(
    _ abioticFactor: AbioticFactor,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    viewContext.state[.abioticFactor] = ViewContext.Value.abioticFactor(abioticFactor)
    
    do {
      
      try serviceManager.call(
        GetMeasurementUnitsByAbioticFactorRequest(
          abioticFactorId: abioticFactor.id))
        .then(in: .main, handleMeasurementUnits)
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
  
  func showMeasurementUnit(_ measurementUnit: MeasurementUnit) {
    
    viewContext.state[.measurementUnit] = ViewContext.Value.measurementUnit(measurementUnit)
    performSegue(to: .addNewMeasurement)
    
  }
  
  func addNewMeasurement(
    value: Double,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let surveyId = survey?.id else {
      handleError(ViewControllerError.noSurveyIdentifier)
      return
    }
    
    guard let abioticFactorId = abioticFactor?.id else {
      handleError(ViewControllerError.noAbioticFactorIdentifier)
      return
    }
    
    guard let measurementUnitId = measurementUnit?.id else {
      handleError(ViewControllerError.noMeasurementUnitIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        AddNewMeasurementRequest(
          token: token,
          surveyId: surveyId,
          abioticFactorId: abioticFactorId,
          measurementUnitId: measurementUnitId,
          value: value))
        .then(in: .main, handleNewMeasurement)
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
  
  func getMeasurements(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }
    
    guard let surveyId = survey?.id else {
      handleError(ViewControllerError.noSurveyIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetMeasurementsBySurveyRequest(
          token: token,
          surveyId: surveyId))
        .then(in: .main, handleMeasurements)
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
  
  func showMeasurement(_ measurement: Measurement) {
    
    viewContext.state[.measurement] = ViewContext.Value.measurement(measurement)
    performSegue(to: .measurement)
    
  }
  
  private func doLogout(_ segueSourceViewController: UIViewController? = nil) {
    
    do {
      try serviceManager.deleteAuthenticatedUser()
    } catch let error {
      LOG.error(error)
    }
    
    segueToMainViewController(segueSourceViewController)
    
  }
  
  func handleMeasurementUnits(_ measurementUnits: [MeasurementUnit]) {
    
    viewContext.state[.measurementUnits] = ViewContext.Value.measurementUnits(measurementUnits)
    performSegue(to: .measurementUnitChoice)
    
  }
  
  func handleAbioticFactors(_ abioticFactors: [AbioticFactor]) {
    
    viewContext.state[.abioticFactors] = ViewContext.Value.abioticFactors(abioticFactors)
    performSegue(to: .abioticFactorChoice)
    
  }
  
  func handleNewSite(_ site: Site) {
    
      viewContext.state[.site] = ViewContext.Value.site(site)
      performSegue(to: .siteNavigationChoice)
  
  }
  
  private func handleSites(_ sites: [Site]) {
    
    if sites.isEmpty {

      showErrorMessage(
        "No Existing Sites",
        ViewControllerError.noOrganizationSites(
          name: organization!.name).localizedDescription)
      
    } else {
      
      viewContext.state[.sites] = ViewContext.Value.sites(sites)
      performSegue(to: .siteChoice)
      
    }
    
  }
  
  func handleSurveys(_ surveys: [Survey]) {
    
    if surveys.isEmpty {
      
      showErrorMessage(
        "No Existing Surveys",
        ViewControllerError.noSiteSurveys(
          name: site!.name).localizedDescription)
      
    } else {
      
      viewContext.state[.surveys] = ViewContext.Value.surveys(surveys)
      performSegue(to: .surveyChoice)
      
    }
    
  }
  
  func handleNewSurvey(_ survey: Survey) {
    
    viewContext.state[.survey] = ViewContext.Value.survey(survey)
    getAbioticFactors()
    
  }
  
  func handleNewMeasurement(_ measurement: Measurement) {
    
    performSegue(to: .abioticFactorChoice)
    
  }
  
  func handleMeasurements(_ measurements: [Measurement]) {
    
    if measurements.isEmpty {
      
      let name = Formatter.basic.string(from: survey!.date)
      showErrorMessage(
        "No Existing Measurements",
        ViewControllerError.noSurveyMeasurements(
          name: name).localizedDescription)
      
    } else {
      
      viewContext.state[.measurements] = ViewContext.Value.measurements(measurements)
      performSegue(to: .measurementChoice)
      
    }
    
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
  
  private func showErrorMessage(_ title: String,
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
  
  private func getUserOrganizations(
    _ authenticatedUser: AuthenticatedUser)
    -> Promise<[Organization]> {
      
      return async(in: .userInitiated) {
        
        status in
        
        return try await(
          self.serviceManager.call(
            GetOrganizationsByUserRequest(
              token: authenticatedUser.token)))
        
      }
      
  }
  
  private func handleOrganizations(
    _ organizations: [Organization]) throws {
    
    if organizations.count == 1 {
      
      viewContext.state[.organizations] = ViewContext.Value.organizations(organizations)
      viewContext.state[.organization] = ViewContext.Value.organization(organizations[0])
      performSegue(to: .topNavigation)
      
    } else if organizations.count > 1 {
      
      viewContext.state[.organizations] = ViewContext.Value.organizations(organizations)
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
        
        let userResponse = try await(
          try self.serviceManager.call(
            GetUserRequest(
              userId: basicAuthUserResponse.userId,
              token: basicAuthUserResponse.token)))
        
        let authenticatedUser = AuthenticatedUserRecord(
          userId: userResponse.id,
          token: basicAuthUserResponse.token,
          fullName: userResponse.fullName,
          email: userResponse.email)
        try self.serviceManager.setAuthenticatedUser(authenticatedUser)
        
        return authenticatedUser
        
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
  
}


