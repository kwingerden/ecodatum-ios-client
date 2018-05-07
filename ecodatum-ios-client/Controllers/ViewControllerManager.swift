import Alamofire
import Foundation
import Hydra
import SwiftValidator
import UIKit

typealias AuthenticatedUser = AuthenticatedUserRecord
typealias EcosystemFactor = EcosystemFactorResponse
typealias Measurement = MeasurementResponse
typealias MeasurementUnit = MeasurementUnitResponse
typealias MediaType = MediaTypeResponse
typealias Organization = OrganizationResponse
typealias OrganizationMember = OrganizationMemberResponse
typealias Photo = PhotoResponse
typealias QualitativeObservationType = QualitativeObservationTypeResponse
typealias QuantitativeObservationType = QuantitativeObservationTypeResponse
typealias Site = SiteResponse

typealias CompletionBlock = () -> Void
typealias PreAsyncBlock = () -> Void
typealias PostAsyncBlock = () -> Void

class ViewControllerManager:
  PhotoHandler,
  SiteHandler {
  
  let viewController: UIViewController
  
  let storyboardSegue: UIStoryboardSegue?
  
  let viewContext: ViewContext
  
  let serviceManager: ServiceManager
  
  lazy var authenticatedUser: AuthenticatedUser? = {
    do {
      return try serviceManager.getAuthenticatedUser()
    } catch let error {
      LOG.error(error.localizedDescription)
      return nil
    }
  }()
  
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

  var primaryAbioticFactor: MeasurementUnit.PrimaryAbioticFactor? {
    get {
      guard let value = viewContext.state[.primaryAbioticFactor] else {
        return nil
      }
      if case let ViewContext.Value.primaryAbioticFactor(primaryAbioticFactor) = value {
        return primaryAbioticFactor
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.primaryAbioticFactor] = ViewContext.Value.primaryAbioticFactor(newValue)
      } else {
        viewContext.state[.primaryAbioticFactor] = nil
      }
    }
  }

  var primaryAbioticFactors: [MeasurementUnit.PrimaryAbioticFactor] {

    return measurementUnits.map {
      $0.primaryAbioticFactor
    }.sorted {
      $0.name < $1.name
    }

  }

  var secondaryAbioticFactor: MeasurementUnit.SecondaryAbioticFactor? {
    get {
      guard let value = viewContext.state[.secondaryAbioticFactor] else {
        return nil
      }
      if case let ViewContext.Value.secondaryAbioticFactor(secondaryAbioticFactor) = value {
        return secondaryAbioticFactor
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.secondaryAbioticFactor] = ViewContext.Value.secondaryAbioticFactor(newValue)
      } else {
        viewContext.state[.secondaryAbioticFactor] = nil
      }
    }
  }

  var secondaryAbioticFactors: [MeasurementUnit.SecondaryAbioticFactor] {
    guard let primaryAbioticFactor = primaryAbioticFactor else {
      return []
    }
    return measurementUnits.filter {
      $0.primaryAbioticFactor.id == primaryAbioticFactor.id
    }.map {
      $0.secondaryAbioticFactor
    }.reduce(into: []) {
      (result, value) in
      if !result.contains(where: { $0.id == value.id }) {
        result.append(value)
      }
    }.sorted {
      $0.name < $1.name
    }
  }

  var measurementUnit: MeasurementUnit? {
    get {
      guard let value = viewContext.state[.measurementUnit] else {
        return nil
      }
      if case let ViewContext.Value.measurementUnit(measurementUnit) = value {
        return measurementUnit
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.measurementUnit] = ViewContext.Value.measurementUnit(newValue)
      } else {
        viewContext.state[.measurementUnit] = nil
      }
    }
  }

  var measurementUnits: [MeasurementUnit] {
    get {
      guard let value = viewContext.state[.measurementUnits] else {
        return []
      }
      if case let ViewContext.Value.measurementUnits(measurementUnits) = value {
        if let primaryAbioticFactor = primaryAbioticFactor,
           let secondaryAbioticFactor = secondaryAbioticFactor {
          return measurementUnits.filter {
            $0.primaryAbioticFactor.id == primaryAbioticFactor.id &&
              $0.secondaryAbioticFactor.id == secondaryAbioticFactor.id
          }.sorted {
            $0.measurementUnit.label < $1.measurementUnit.label
          }
        } else {
          return measurementUnits.sorted {
            $0.measurementUnit.label < $1.measurementUnit.label
          }
        }
      } else {
        return []
      }
    }
    set {
      viewContext.state[.measurementUnits] = ViewContext.Value.measurementUnits(newValue)
    }
  }

  var ecosystemFactors: [EcosystemFactor] {
    get {
      guard let value = viewContext.state[.ecosystemFactors] else {
        return []
      }
      if case let ViewContext.Value.ecosystemFactors(ecosystemFactors) = value {
        return ecosystemFactors
      } else {
        return []
      }
    }
    set {
      viewContext.state[.ecosystemFactors] = ViewContext.Value.ecosystemFactors(newValue)
    }
  }
  
  var mediaTypes: [MediaType] {
    get {
      guard let value = viewContext.state[.mediaTypes] else {
        return []
      }
      if case let ViewContext.Value.mediaTypes(mediaTypes) = value {
        return mediaTypes
      } else {
        return []
      }
    }
    set {
      viewContext.state[.mediaTypes] = ViewContext.Value.mediaTypes(newValue)
    }
  }
  
  var qualitativeObservationTypes: [QualitativeObservationType] {
    get {
      guard let value = viewContext.state[.qualitativeObservationTypes] else {
        return []
      }
      if case let ViewContext.Value.qualitativeObservationTypes(qualitativeObservationTypes) = value {
        return qualitativeObservationTypes
      } else {
        return []
      }
    }
    set {
      viewContext.state[.qualitativeObservationTypes] = ViewContext.Value.qualitativeObservationTypes(newValue)
    }
  }
  
  var quantitativeObservationTypes: [QuantitativeObservationType] {
    get {
      guard let value = viewContext.state[.quantitativeObservationTypes] else {
        return []
      }
      if case let ViewContext.Value.quantitativeObservationTypes(quantitativeObservationTypes) = value {
        return quantitativeObservationTypes
      } else {
        return []
      }
    }
    set {
      viewContext.state[.quantitativeObservationTypes] = ViewContext.Value.quantitativeObservationTypes(newValue)
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

  var measurement: Measurement? {
    get {
      guard let value = viewContext.state[.measurement] else {
        return nil
      }
      if case let ViewContext.Value.measurement(measurement) = value {
        return measurement
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.measurement] = ViewContext.Value.measurement(newValue)
      } else {
        viewContext.state[.measurement] = nil
      }
    }
  }
  
  var measurements: [Measurement] {
    get {
      guard let value = viewContext.state[.measurements] else {
        return []
      }
      if case let ViewContext.Value.measurements(measurements) = value {
        return measurements
      } else {
        return []
      }
    }
    set {
      viewContext.state[.measurements] = ViewContext.Value.measurements(newValue)
    }
  }
  
  var photo: Photo? {
    get {
      guard let value = viewContext.state[.photo] else {
        return nil
      }
      if case let ViewContext.Value.photo(photo) = value {
        return photo
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        viewContext.state[.photo] = ViewContext.Value.photo(newValue)
      } else {
        viewContext.state[.photo] = nil
      }
    }
  }
  
  var photos: [Photo] {
    get {
      guard let value = viewContext.state[.photos] else {
        return []
      }
      if case let ViewContext.Value.photos(photos) = value {
        return photos.sorted {
          $0.createdAt < $1.createdAt
        }
      } else {
        return []
      }
    }
    set {
      viewContext.state[.photos] = ViewContext.Value.photos(newValue)
    }
  }

  var photoId: Identifier? {
    return ViewControllerSegue.newPhoto == viewControllerSegue ? nil : photo?.id
  }

  var photoHandler: PhotoHandler {
    var newPhotoHandler: PhotoHandler = self
    if let photoHandler = storyboardSegue?.source as? PhotoHandler {
      newPhotoHandler = photoHandler
    }
    return newPhotoHandler
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
                    to: ViewControllerSegue,
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
  
  func setImage(_ imageView: UIImageView, imageId: Identifier) {
    serviceManager.setImage(imageView, imageId: imageId)
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
          name: name,
          description: description,
          latitude: latitude,
          longitude: longitude,
          altitude: altitude,
          horizontalAccuracy: horizontalAccuracy,
          verticalAccuracy: verticalAccuracy,
          organizationId: organizationId))
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

  func getMeasurementUnits(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil ) {

    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }

    do {

      try serviceManager.call(
        GetMeasurementUnitsRequest())
        .then(in: .main) {
          measurementUnits in
          self.handleMeasurementUnits(measurementUnits)
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

  func handleMeasurementUnits(_ measurementUnits: [MeasurementUnit]) {

    self.measurementUnits = measurementUnits

    if measurementUnits.isEmpty {

      showErrorMessage(
        "No Existing Measurement Units",
        ViewControllerError.noMeasurementUnits.localizedDescription)

    }

  }

  func getEcoDatumFactors(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil ) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetEcosystemFactorsRequest())
        .then(in: .main) {
          ecosystemFactors in
          self.ecosystemFactors = ecosystemFactors
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
  
  func getMediaTypes(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil ) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetMediaTypesRequest())
        .then(in: .main) {
          mediaTypes in
          self.mediaTypes = mediaTypes
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
  
  func getQualitativeObservationTypes(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil ) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetQualitativeObservationTypesRequest())
        .then(in: .main) {
          qualitativeObservationTypes in
          self.qualitativeObservationTypes = qualitativeObservationTypes
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
  
  func getQuantitativeObservationTypes(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil,
    completionBlock: CompletionBlock? = nil ) {
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetQuantitativeObservationTypesRequest())
        .then(in: .main) {
          quantitativeObservationTypes in
          self.quantitativeObservationTypes = quantitativeObservationTypes
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
  
  func showPrimaryAbioticFactors() {

    performSegue(to: .primaryAbioticFactorChoice)

  }

  func findPrimaryAbioticFactor(_ name: String) -> MeasurementUnit.PrimaryAbioticFactor? {

    return measurementUnits.filter {
      $0.primaryAbioticFactor.name.lowercased() == name.lowercased()
    }.first?.primaryAbioticFactor

  }

  func showSecondaryAbioticFactors(_ primaryAbioticFactor: MeasurementUnit.PrimaryAbioticFactor) {

    self.primaryAbioticFactor = primaryAbioticFactor
    performSegue(to: .secondaryAbioticFactorChoice)

  }

  func showMeasurementUnits(_ secondaryAbioticFactor: MeasurementUnit.SecondaryAbioticFactor) {

    self.secondaryAbioticFactor = secondaryAbioticFactor
    performSegue(to: .measurementUnitChoice)

  }

  func showMeasurement(_ measurementUnit: MeasurementUnit) {

    self.measurementUnit = measurementUnit
    performSegue(to: .newMeasurement)

  }

  func addNewMeasurement(
    value: Double,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    /*
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
    */
  }
  
  func getMeasurements(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    /*
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
    */
    
  }

  func newOrUpdatePhoto(
    base64Encoded: Base64Encoded,
    description: String,
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {

    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    /*
    guard let surveyId = survey?.id else {
      handleError(ViewControllerError.noSurveyIdentifier)
      return
    }

    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }

    do {

      try serviceManager.call(
          NewOrUpdatePhotoRequest(
            token: token,
            id: photoId,
            base64Encoded: base64Encoded,
            description: description,
            surveyId: surveyId))
        .then(in: .main) {
          photo in
          if self.photoId == nil {
            self.photoHandler.handleNewPhoto(photo: photo)
          } else {
            self.photoHandler.handleUpdatedPhoto(photo: photo)
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
    */

  }

  func showPhoto(_ photo: Photo, segue: ViewControllerSegue) {
    
    self.photo = photo
    performSegue(to: segue)
    
  }
  
  func chooseExistingPhoto(
    preAsyncBlock: PreAsyncBlock? = nil,
    postAsyncBlock: PostAsyncBlock? = nil) {
    
    guard let token = authenticatedUser?.token else {
      handleError(ViewControllerError.noAuthenticationToken)
      return
    }

    /*
    guard let surveyId = survey?.id else {
      handleError(ViewControllerError.noSurveyIdentifier)
      return
    }
    
    if let preAsyncBlock = preAsyncBlock {
      preAsyncBlock()
    }
    
    do {
      
      try serviceManager.call(
        GetPhotosBySurveyRequest(
          token: token,
          surveyId: surveyId))
        .then(in: .main, handlePhotos)
        .catch(in: .main, handleError)
        .always(in: .main) {
          if let postAsyncBlock = postAsyncBlock {
            postAsyncBlock()
          }
      }
      
    } catch let error {
      
      handleError(error)
      
    }
    */
    
  }
  
  func deletePhoto(
    photo: Photo,
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
        DeletePhotoByIdRequest(
          token: token,
          photoId: photo.id))
        .then(in: .main) {
          _ in
          self.photoHandler.handleDeletedPhoto(photo: photo)
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

  func handleNewMeasurement(_ measurement: Measurement) {
    
    performSegue(to: .surveyNavigationChoice)
    
  }
  
  func handleMeasurements(_ measurements: [Measurement]) {

    self.measurements = measurements

    /*
    if measurements.isEmpty {
      
      let name = Formatter.basic.string(from: survey!.date)
      showErrorMessage(
        "No Existing Measurements",
        ViewControllerError.noSurveyMeasurements(
          name: name).localizedDescription)
      
    } else {

      performSegue(to: .measurementChoice)
      
    }
    */
    
  }

  func handleNewPhoto(photo: Photo) {

    self.photo = photo
    photos.append(photo)
    performSegue(to: .surveyNavigationChoice)

  }

  func handleUpdatedPhoto(photo: Photo) {

    self.photo = photo
    if let index = photos.index(where: { $0.id == photo.id }) {
      photos.replaceSubrange(index...index, with: [photo])
    }

  }

  func handleDeletedPhoto(photo: Photo) {

    if let index = photos.index(where: { $0.id == photo.id }) {
      photos.remove(at: index)
    }

  }
  
  func handlePhotos(_ photos: [Photo]) {
    
    self.photos = photos

    /*
    if photos.isEmpty {
 
      showErrorMessage(
        "No Existing Photos",
        ViewControllerError.noSurveyPhotos(
          date: survey!.date).localizedDescription)
      
    } else {
      
      performSegue(to: .photoChoice)
      
    }
    */
    
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
          email: userResponse.email,
          isRootUser: basicAuthUserResponse.isRootUser)
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
  
  private func doLogout(_ segueSourceViewController: UIViewController? = nil) {
    
    do {
      try serviceManager.deleteAuthenticatedUser()
    } catch let error {
      LOG.error(error)
    }
    
    segueToMainViewController(segueSourceViewController)
    
  }
  
  
}


