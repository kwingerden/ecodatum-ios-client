import Foundation
import SwiftValidator
import UIKit

fileprivate enum EcoFactor: String {

  case Abiotic
  case Biotic

  static let all: [EcoFactor] = [
    .Abiotic,
    .Biotic
  ]

}

fileprivate enum AbioticFactor: String {

  case Air
  case Soil
  case Water

  static let all: [AbioticFactor] = [
    .Air,
    .Soil,
    .Water
  ]

}

fileprivate enum BioticFactor: String {

  case Coliform
  case Photo
  case TreesAndCarbon = "Trees and Carbon"

  static let all: [BioticFactor] = [
    .Coliform,
    .Photo,
    .TreesAndCarbon
  ]

}

fileprivate enum AirDataType: String {

  case Velocity
  case CarbonDioxide = "Carbon Dioxide"
  case Light
  case PAR
  case RelativeHumidity = "Relative Humidity"
  case Temperature
  case UVB

  static let all: [AirDataType] = [
    .Velocity,
    .CarbonDioxide,
    .Light,
    .PAR,
    .RelativeHumidity,
    .Temperature,
    .UVB,
  ]

}

fileprivate enum SoilDataType: String {

  case Nitrogen
  case Phosphorus
  case Potassium
  case Moisture
  case Texture
  case Temperature

  static let all: [SoilDataType] = [
    .Nitrogen,
    .Phosphorus,
    .Potassium,
    .Moisture,
    .Texture,
    .Temperature
  ]

}

fileprivate enum WaterDataType: String {

  case Conductivity
  case DissolvedOxygen = "Dissolved Oxygen"
  case FlowRate = "Flow Rate"
  case Nitrate
  case Odor
  case PAR
  case pH
  case Phosphate
  case Temperature
  case Turbidity

  static let all: [WaterDataType] = [
    .Conductivity,
    .DissolvedOxygen,
    .FlowRate,
    .Nitrate,
    .Odor,
    .PAR,
    .pH,
    .Phosphate,
    .Temperature,
    .Turbidity
  ]

}

fileprivate enum DataType {

  case Air([AirDataType])
  case Soil([SoilDataType])
  case Water([WaterDataType])

  static let all: [DataType] = [
    .Air(AirDataType.all),
    .Soil(SoilDataType.all),
    .Water(WaterDataType.all)
  ]

}

fileprivate enum DataTypeChoice {

  case Air(AirDataType)
  case Soil(SoilDataType)
  case Water(WaterDataType)

  static func ==(lhs: DataTypeChoice, rhs: DataTypeChoice) -> Bool {
    switch (lhs, rhs) {
    case let (.Air(v1), .Air(v2)) where v1 == v2: return true
    case let (.Soil(v1), .Soil(v2)) where v1 == v2: return true
    case let (.Water(v1), .Water(v2)) where v1 == v2: return true
    default: return false
    }
  }

}

fileprivate enum DataUnitChoice: String {

  case PartsPerMillion = "ppm \\ (Parts \\ Per \\ Million)"
  case Lux = "Lux"
  case PhotosyntheticPhotonFluxDensity = "PPFD \\ (Photosynthetic \\ Photon \\ Flux \\ Density)"
  case MicromolesPerMetersSquaredAndSeconds = "\\mu mol \\ m^{-2}s^{-1}"
  case Percent = "\\%"
  case DegreesCelsius = "^{\\circ}C"
  case DegreesFahrenheit = "^{\\circ}F"
  case MegawattsPerMeterSquared = "\\frac{mW}{m^{2}}"
  case MetersPerSecond = "\\frac{m}{s}"
  case MilesPerHour = "mph"
  case PoundsPerAcre = "\\frac{lb}{a}"
  case MicrosiemensPerCentimeter = "\\frac{\\mu S}{cm}"
  case FeetPerSecond = "\\frac{ft}{s}"
  case MilligramsPerLiter = "\\frac{mg}{L}"
  case NephelometricTurbidityUnits = "NTU \\ (Nephelometric \\ Turbidity \\ Units)"
  case JacksonTurbidityUnits = "JTU \\ (Jackson \\ Turbidity \\ Units)"

  case _Soil_Potassium_Scale_ = "Potassium \\ Scale"
  case _Soil_Texture_Scale_ = "Texture \\ Scale"
  case _Water_Odor_Scale_ = "Odor \\ Scale"
  case _Water_pH_Scale_ = "pH \\ Scale"
  case _Water_Turbidity_Scale_ = "Turbidity \\ Scale"

  static func units(_ dataType: DataTypeChoice) -> [DataUnitChoice] {

    switch dataType {

      // ** AIR

    case .Air(let airDataType) where airDataType == .CarbonDioxide:
      return [
        .PartsPerMillion
      ]

    case .Air(let airDataType) where airDataType == .Light:
      return [
        .Lux
      ]

    case .Air(let airDataType) where airDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]

    case .Air(let airDataType) where airDataType == .RelativeHumidity:
      return [
        .Percent
      ]

    case .Air(let airDataType) where airDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

    case .Air(let airDataType) where airDataType == .UVB:
      return [
        .MegawattsPerMeterSquared,
        .Percent
      ]

    case .Air(let airDataType) where airDataType == .Velocity:
      return [
        .MetersPerSecond,
        .MilesPerHour
      ]

      // ** SOIL

    case .Soil(let soilDataType)
         where soilDataType == .Nitrogen || soilDataType == .Phosphorus:
      return [
        .PoundsPerAcre
      ]

    case .Soil(let soilDataType) where soilDataType == .Potassium:
      return [
        ._Soil_Potassium_Scale_
      ]

    case .Soil(let soilDataType) where soilDataType == .Moisture:
      return [
        .Percent
      ]

    case .Soil(let soilDataType) where soilDataType == .Texture:
      return [
        ._Soil_Texture_Scale_
      ]

    case .Soil(let soilDataType) where soilDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

      // ** WATER

    case .Water(let waterDataType) where waterDataType == .Conductivity:
      return [
        .MicrosiemensPerCentimeter
      ]

    case .Water(let waterDataType) where waterDataType == .DissolvedOxygen:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter,
        .Percent
      ]

    case .Water(let waterDataType) where waterDataType == .FlowRate:
      return [
        .MetersPerSecond,
        .FeetPerSecond
      ]

    case .Water(let waterDataType) where waterDataType == .Nitrate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]

    case .Water(let waterDataType) where waterDataType == .Odor:
      return [
        ._Water_Odor_Scale_
      ]

    case .Water(let waterDataType) where waterDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]

    case .Water(let waterDataType) where waterDataType == .pH:
      return [
        ._Water_pH_Scale_
      ]

    case .Water(let waterDataType) where waterDataType == .Phosphate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]

    case .Water(let waterDataType) where waterDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]

    case .Water(let waterDataType) where waterDataType == .Turbidity:
      return [
        .NephelometricTurbidityUnits,
        .JacksonTurbidityUnits,
        ._Water_Turbidity_Scale_
      ]

    default: return []

    }

  }

}

fileprivate enum SoilPotassiumScale {

  case Low(index: Int, label: String)
  case Medium(index: Int, label: String)
  case High(index: Int, label: String)

  static func ==(_ lhs: SoilPotassiumScale, _ rhs: SoilPotassiumScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .Low(let index, _): lhsIndex = index
    case .Medium(let index, _): lhsIndex = index
    case .High(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .Low(let index, _): rhsIndex = index
    case .Medium(let index, _): rhsIndex = index
    case .High(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [SoilPotassiumScale] = [
    .Low(index: 0, label: "Low"),
    .Medium(index: 1, label: "Medium"),
    .High(index: 2, label: "High")
  ]

}

fileprivate enum WaterOdorScale {

  case NoOdor(index: Int, label: String)
  case SlightOdor(index: Int, label: String)
  case Smelly(index: Int, label: String)
  case VerySmelly(index: Int, label: String)
  case Devastating(index: Int, label: String)

  static func ==(_ lhs: WaterOdorScale, _ rhs: WaterOdorScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .NoOdor(let index, _): lhsIndex = index
    case .SlightOdor(let index, _): lhsIndex = index
    case .Smelly(let index, _): lhsIndex = index
    case .VerySmelly(let index, _): lhsIndex = index
    case .Devastating(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .NoOdor(let index, _): rhsIndex = index
    case .SlightOdor(let index, _): rhsIndex = index
    case .Smelly(let index, _): rhsIndex = index
    case .VerySmelly(let index, _): rhsIndex = index
    case .Devastating(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [WaterOdorScale] = [
    .NoOdor(index: 0, label: "No Odor"),
    .SlightOdor(index: 1, label: "Slight Odor"),
    .Smelly(index: 2, label: "Smelly"),
    .VerySmelly(index: 3, label: "Very Smelly"),
    .Devastating(index: 4, label: "Devastating")
  ]

}

fileprivate enum WaterTurbidityScale {

  case CrystalClear(index: Int, label: String)
  case SlightlyCloudy(index: Int, label: String)
  case ModeratelyCloudy(index: Int, label: String)
  case VeryCloudy(index: Int, label: String)
  case BlackishOrBrownish(index: Int, label: String)

  static func ==(_ lhs: WaterTurbidityScale, _ rhs: WaterTurbidityScale) -> Bool {

    var lhsIndex = 0
    switch lhs {
    case .CrystalClear(let index, _): lhsIndex = index
    case .SlightlyCloudy(let index, _): lhsIndex = index
    case .ModeratelyCloudy(let index, _): lhsIndex = index
    case .VeryCloudy(let index, _): lhsIndex = index
    case .BlackishOrBrownish(let index, _): lhsIndex = index
    }

    var rhsIndex = 0
    switch rhs {
    case .CrystalClear(let index, _): rhsIndex = index
    case .SlightlyCloudy(let index, _): rhsIndex = index
    case .ModeratelyCloudy(let index, _): rhsIndex = index
    case .VeryCloudy(let index, _): rhsIndex = index
    case .BlackishOrBrownish(let index, _): rhsIndex = index
    }

    return lhsIndex == rhsIndex

  }

  static let all: [WaterTurbidityScale] = [
    .CrystalClear(index: 0, label: "Crystal Clear"),
    .SlightlyCloudy(index: 1, label: "Slightly Cloudy"),
    .ModeratelyCloudy(index: 2, label: "Moderately Cloudy"),
    .VeryCloudy(index: 3, label: "Very Cloudy"),
    .BlackishOrBrownish(index: 4, label: "Blackish or Brownish")
  ]

}

fileprivate struct DataValue {

  enum Sign {
    case positive
    case negative
  }

  let sign: Sign
  let number: String
  let decimalPoint: Bool
  let fraction: String?

  var stringValue: String {
    return toString()
  }

  var doubleValue: Double {
    return Double(toString())!
  }

  init(sign: Sign = .positive,
       number: String = "0",
       decimalPoint: Bool = false,
       fraction: String? = nil) {
    self.sign = sign
    self.number = number
    self.decimalPoint = decimalPoint
    self.fraction = fraction
  }

  func toggleSign() -> DataValue {

    if doubleValue == 0 {

      return DataValue(
        sign: .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)

    } else {

      return DataValue(
        sign: sign == .positive ? .negative : .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)

    }

  }

  func addDecimalPoint() -> DataValue {

    if decimalPoint {

      return self

    } else {

      return DataValue(
        sign: sign,
        number: number,
        decimalPoint: true,
        fraction: nil)

    }

  }

  func addDigit(_ digit: Int) -> DataValue {

    if let fraction = fraction {

      return DataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(fraction)\(digit)")

    } else if decimalPoint {

      return DataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(digit)")

    } else {

      var newNumber = "\(number)\(digit)"
      if doubleValue == 0 {
        newNumber = "\(digit)"
      }
      return DataValue(
        sign: sign,
        number: newNumber,
        decimalPoint: false,
        fraction: nil)

    }

  }

  func deleteDigit() -> DataValue {

    var newSign = sign
    if doubleValue == 0 {
      newSign = .positive
    }

    if let fraction = fraction {

      var newFraction = fraction
      newFraction.removeLast()
      return DataValue(
        sign: newSign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: newFraction.count == 0 ? nil : newFraction)

    } else if decimalPoint {

      return DataValue(
        sign: newSign,
        number: number,
        decimalPoint: false,
        fraction: nil)

    } else {

      var newNumber = number
      newNumber.removeLast()

      if newNumber.count == 0 {
        newSign = .positive
      } else if let intNumber = Int(newNumber),
                intNumber == 0 {
        newSign = .positive
      }

      return DataValue(
        sign: newSign,
        number: newNumber.count == 0 ? "0" : newNumber,
        decimalPoint: false,
        fraction: nil)

    }

  }

  static func ==(_ lhs: DataValue, _ rhs: DataValue) -> Bool {
    return lhs.sign == rhs.sign &&
      lhs.number == rhs.number &&
      lhs.decimalPoint == rhs.decimalPoint &&
      lhs.fraction == rhs.fraction
  }

  private func toString() -> String {

    let sign = self.sign == .positive ? "" : "-"
    let decimalPoint = self.decimalPoint ? "." : ""

    if let fraction = fraction {
      return "\(sign)\(number).\(fraction)"
    } else if Int(number) == 0 {
      return "0\(decimalPoint)"
    } else {
      return "\(sign)\(number)\(decimalPoint)"
    }

  }

}

fileprivate struct AbioticFactorChoices {

  let abioticFactor: AbioticFactor?
  let dataType: DataTypeChoice?
  let dataUnit: DataUnitChoice?
  let dataValue: Any?

  init(abioticFactor: AbioticFactor? = nil,
       dataType: DataTypeChoice? = nil,
       dataUnit: DataUnitChoice? = nil,
       dataValue: Any? = nil) {
    self.abioticFactor = abioticFactor
    self.dataType = dataType
    self.dataUnit = dataUnit
    self.dataValue = dataValue
  }

}

fileprivate struct BioticFactorChoices {

  let bioticFactor: BioticFactor?

  init(bioticFactor: BioticFactor? = nil) {
    self.bioticFactor = bioticFactor
  }

}

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var tableView: UITableView!

  private var dateChoice: Date = Date()

  private var timeChoice: Date = Date()

  private var ecoFactorChoice: EcoFactor? = nil

  private var abioticFactorChoices: AbioticFactorChoices? = nil

  private var bioticFactorChoices: BioticFactorChoices? = nil

  private var numberOfSections: Int = 3

  private let DATE_FORMATTER: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d yyyy"
    return formatter
  }()

  private let TIME_FORMATTER: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a zzz"
    return formatter
  }()

  override func viewDidLoad() {

    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120

  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false

  }

  @IBAction override func touchUpInside(_ sender: UIButton) {

  }

  override func postAsyncUIOperation() {

    super.postAsyncUIOperation()

    if viewControllerManager.isFormSheetSegue {
      dismiss(animated: true, completion: nil)
    }

  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let identifier = segue.identifier {

      switch identifier {

      case "dateChoice":
        if let destination = segue.destination as? DateChoiceViewController {
          destination.dateChoice = dateChoice
          destination.handleDateChoice = handleDateChoice
        }

      case "timeChoice":
        if let destination = segue.destination as? TimeChoiceViewController {
          destination.timeChoice = timeChoice
          destination.handleTimeChoice = handleTimeChoice
        }

      case "ecoFactorChoice":
        if let destination = segue.destination as? EcoFactorChoiceViewController {
          destination.ecoFactorChoice = ecoFactorChoice
          destination.handleEcoFactorChoice = handleEcoFactorChoice
        }

      case "abioticFactorChoice":
        if let destination = segue.destination as? AbioticFactorChoiceViewController {
          destination.abioticFactorChoice = abioticFactorChoices?.abioticFactor
          destination.handleAbioticFactorChoice = handleAbioticFactorChoice
        }

      case "dataTypeChoice":
        if let destination = segue.destination as? DataTypeChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataTypeChoice = handleDataTypeChoice
        }

      case "dataUnitChoice":
        if let destination = segue.destination as? DataUnitChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataUnitChoice = handleDataUnitChoice
        }

      case "dataValueChoice":
        if let destination = segue.destination as? DataValueChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataValueChoice = handleDataValueChoice
        }

      case "pHValueChoice":
        if let destination = segue.destination as? PhValueChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataValueChoice = handleDataValueChoice
        }

      case "soilPotassiumChoice":
        if let destination = segue.destination as? SoilPotassiumChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleSoilPotassiumChoice = handleSoilPotassiumChoice
        }

      case "waterOdorChoice":
        if let destination = segue.destination as? WaterOdorChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleWaterOdorChoice = handleWaterOdorChoice
        }

      case "waterTurbidityChoice":
        if let destination = segue.destination as? WaterTurbidityChoiceViewController,
           let abioticFactorChoices = abioticFactorChoices {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleWaterTurbidityChoice = handleWaterTurbidityChoice
        }

      default:
        break

      }

    }

  }

  func presentDateChoice() {
    performSegue(withIdentifier: "dateChoice", sender: nil)
  }

  func handleDateChoice(_ date: Date) {

    self.dateChoice = date
    tableView.reloadSections([0], with: .automatic)

  }

  func presentTimeChoice() {
    performSegue(withIdentifier: "timeChoice", sender: nil)
  }

  func handleTimeChoice(_ date: Date) {

    self.timeChoice = date
    tableView.reloadSections([1], with: .automatic)

  }

  func presentEcoFactorChoice() {
    performSegue(withIdentifier: "ecoFactorChoice", sender: nil)
  }

  fileprivate func handleEcoFactorChoice(_ ecoFactor: EcoFactor) {

    if self.ecoFactorChoice == ecoFactor {
      return
    }

    self.ecoFactorChoice = ecoFactor
    tableView.reloadSections([2], with: .automatic)

    if ecoFactorChoice == .Abiotic {
      abioticFactorChoices = AbioticFactorChoices()
    } else {
      bioticFactorChoices = BioticFactorChoices()
    }

    if numberOfSections > 3 {
      for sectionIndex in (4...numberOfSections).reversed() {
        numberOfSections = sectionIndex - 1
        tableView.deleteSections([numberOfSections], with: .automatic)
      }
    }

    numberOfSections = 4
    tableView.insertSections([3], with: .automatic)

  }

  func presentAbioticFactorChoice() {
    performSegue(withIdentifier: "abioticFactorChoice", sender: nil)
  }

  fileprivate func handleAbioticFactorChoice(_ abioticFactor: AbioticFactor) {

    if let abioticFactorChoices = abioticFactorChoices,
       abioticFactor == abioticFactorChoices.abioticFactor {
      return
    }

    abioticFactorChoices = AbioticFactorChoices(
      abioticFactor: abioticFactor,
      dataType: nil)
    tableView.reloadSections([3], with: .automatic)

    if numberOfSections > 4 {
      for sectionIndex in (5...numberOfSections).reversed() {
        numberOfSections = sectionIndex - 1
        tableView.deleteSections([numberOfSections], with: .automatic)
      }
    }

    numberOfSections = 5
    tableView.insertSections([4], with: .automatic)

  }

  func presentDataTypeChoice() {
    performSegue(withIdentifier: "dataTypeChoice", sender: nil)
  }

  fileprivate func handleDataTypeChoice(_ dataTypeChoice: DataTypeChoice) {

    if let abioticFactorChoices = abioticFactorChoices,
       let dataType = abioticFactorChoices.dataType,
       dataType == dataTypeChoice {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: dataTypeChoice)
    }
    tableView.reloadSections([4], with: .automatic)

    if numberOfSections > 5 {
      for sectionIndex in (6...numberOfSections).reversed() {
        numberOfSections = sectionIndex - 1
        tableView.deleteSections([numberOfSections], with: .automatic)
      }
    }

    numberOfSections = 6
    tableView.insertSections([5], with: .automatic)

  }

  func presentDataUnitChoice() {
    performSegue(withIdentifier: "dataUnitChoice", sender: nil)
  }

  fileprivate func handleDataUnitChoice(_ dataUnitChoice: DataUnitChoice) {

    if let abioticFactorChoices = abioticFactorChoices,
       let dataUnit = abioticFactorChoices.dataUnit,
       dataUnit == dataUnitChoice {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataUnit: dataUnitChoice)
    }
    tableView.reloadSections([5], with: .automatic)

    if numberOfSections > 6 {
      for sectionIndex in (7...numberOfSections).reversed() {
        numberOfSections = sectionIndex - 1
        tableView.deleteSections([numberOfSections], with: .automatic)
      }
    }

    numberOfSections = 7
    tableView.insertSections([6], with: .automatic)

  }

  func presentDataValueChoice() {

    guard let dataUnit = abioticFactorChoices?.dataUnit else {
      fatalError()
    }

    switch dataUnit {

    case ._Water_pH_Scale_:
      performSegue(withIdentifier: "pHValueChoice", sender: nil)

    case ._Soil_Potassium_Scale_:
      performSegue(withIdentifier: "soilPotassiumChoice", sender: nil)

    case ._Water_Odor_Scale_:
      performSegue(withIdentifier: "waterOdorChoice", sender: nil)

    case ._Water_Turbidity_Scale_:
      performSegue(withIdentifier: "waterTurbidityChoice", sender: nil)

    default:
      performSegue(withIdentifier: "dataValueChoice", sender: nil)

    }

  }

  fileprivate func handleDataValueChoice(_ dataValueChoice: DataValue) {

    if let dataValue = abioticFactorChoices?.dataValue as? DataValue,
       dataValueChoice == dataValue {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {

      var newDataValueChoice = dataValueChoice
      if newDataValueChoice.fraction == nil && newDataValueChoice.decimalPoint {
        newDataValueChoice = DataValue(
          sign: newDataValueChoice.sign,
          number: newDataValueChoice.number,
          decimalPoint: false,
          fraction: nil)
      }

      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataUnit: abioticFactorChoices.dataUnit,
        dataValue: newDataValueChoice)

    }

    updateAbioticDataValueRow(tableView)

  }

  fileprivate func handleSoilPotassiumChoice(_ soilPotassiumChoice: SoilPotassiumScale) {

    if let dataValue = abioticFactorChoices?.dataValue as? SoilPotassiumScale,
       soilPotassiumChoice == dataValue {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataUnit: abioticFactorChoices.dataUnit,
        dataValue: soilPotassiumChoice)
    }

    updateAbioticDataValueRow(tableView)

  }

  fileprivate func handleWaterOdorChoice(_ waterOdorChoice: WaterOdorScale) {

    if let dataValue = abioticFactorChoices?.dataValue as? WaterOdorScale,
       waterOdorChoice == dataValue {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataUnit: abioticFactorChoices.dataUnit,
        dataValue: waterOdorChoice)
    }

    updateAbioticDataValueRow(tableView)

  }

  fileprivate func handleWaterTurbidityChoice(_ waterTurbidityChoice: WaterTurbidityScale) {

    if let dataValue = abioticFactorChoices?.dataValue as? WaterTurbidityScale,
       waterTurbidityChoice == dataValue {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataUnit: abioticFactorChoices.dataUnit,
        dataValue: waterTurbidityChoice)
    }

    updateAbioticDataValueRow(tableView)

  }

  private func updateAbioticDataValueRow(_ tableView: UITableView) {
    tableView.reloadSections([6], with: .automatic)

    if numberOfSections > 7 {
      for sectionIndex in (8...numberOfSections).reversed() {
        numberOfSections = sectionIndex - 1
        tableView.deleteSections([numberOfSections], with: .automatic)
      }
    }

    numberOfSections = 8
    tableView.insertSections([7], with: .automatic)
  }

  fileprivate func handleSaveData() {
    print("Save Data")
  }

}

extension NewOrUpdateDataViewController: UITableViewDelegate {

}

extension NewOrUpdateDataViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    return nil
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    switch ecoFactorChoice {

    case .Abiotic? where indexPath.section == 5: // Abiotic -> Data Unit
      return 82

    case .Abiotic? where indexPath.section == 7: // Abiotic -> Save Button
      return 115

    case .Biotic?:
      return 0

    default:
      return 60

    }

  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.section {

    case 0: return makeDateChoiceCell(tableView, indexPath)
    case 1: return makeTimeChoiceCell(tableView, indexPath)
    case 2: return makeEcoFactorChoiceCell(tableView, indexPath)
    case 3: return makeAbioticFactorChoiceCell(tableView, indexPath)
    case 4: return makeDataTypeChoiceCell(tableView, indexPath)
    case 5: return makeDataUnitChoiceCell(tableView, indexPath)
    case 6: return makeDataValueChoiceCell(tableView, indexPath)
    case 7: return makeSaveDataCell(tableView, indexPath)
    default: return UITableViewCell()

    }

  }

  private func makeDateChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dateChoice",
      for: indexPath) as! DateChoiceTableViewCell

    cell.dateLabel.text = DATE_FORMATTER.string(from: dateChoice)
    cell.presentDateChoice = presentDateChoice

    return cell

  }

  private func makeTimeChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "timeChoice",
      for: indexPath) as! TimeChoiceTableViewCell

    cell.timeLabel.text = TIME_FORMATTER.string(from: timeChoice)
    cell.presentTimeChoice = presentTimeChoice

    return cell

  }

  private func makeEcoFactorChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ecoFactorChoice",
      for: indexPath) as! EcoFactorChoiceTableViewCell

    if let ecoFactorChoice = ecoFactorChoice {

      cell.ecoFactorLabel.text = ecoFactorChoice.rawValue
      cell.ecoFactorLabel.textColor = .black

    } else {

      cell.ecoFactorLabel.text = "Choose Ecosystem Factor"
      cell.ecoFactorLabel.textColor = .lightGray

    }

    cell.presentEcoFactorChoice = presentEcoFactorChoice

    return cell

  }

  private func makeAbioticFactorChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "abioticFactorChoice",
      for: indexPath) as! AbioticFactorChoiceTableViewCell

    if let abioticFactor = abioticFactorChoices?.abioticFactor {

      cell.abioticFactorLabel.text = abioticFactor.rawValue
      cell.abioticFactorLabel.textColor = .black

    } else {

      cell.abioticFactorLabel.text = "Choose Abiotic Factor"
      cell.abioticFactorLabel.textColor = .lightGray

    }

    cell.presentAbioticFactorChoice = presentAbioticFactorChoice

    return cell

  }

  private func makeDataTypeChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dataTypeChoice",
      for: indexPath) as! DataTypeChoiceTableViewCell

    if let abioticFactorChoices = abioticFactorChoices,
       let dataType = abioticFactorChoices.dataType {

      switch dataType {

      case .Air(let airDataType):
        cell.dataTypeLabel.text = airDataType.rawValue

      case .Soil(let soilDataType):
        cell.dataTypeLabel.text = soilDataType.rawValue

      case .Water(let waterDataType):
        cell.dataTypeLabel.text = waterDataType.rawValue

      }

      cell.dataTypeLabel.textColor = .black

    } else {

      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: cell.dataTypeLabel.text = "Choose Air Data Type"
        case .Soil: cell.dataTypeLabel.text = "Choose Soil Data Type"
        case .Water: cell.dataTypeLabel.text = "Choose Water Data Type"
        }
      }

      cell.dataTypeLabel.textColor = .lightGray

    }

    cell.presentDataTypeChoice = presentDataTypeChoice

    return cell

  }

  private func makeDataUnitChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    guard let abioticFactorChoices = abioticFactorChoices else {
      fatalError()
    }

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dataUnitChoice",
      for: indexPath) as! DataUnitChoiceTableViewCell

    if let dataUnit = abioticFactorChoices.dataUnit {

      cell.dataUnitLabel.latex = dataUnit.rawValue
      cell.dataUnitLabel.isHidden = false
      cell.chooseDataUnitLabel.isHidden = true

    } else {

      if let abioticFactor = abioticFactorChoices.abioticFactor {

        switch abioticFactor {
        case .Air: cell.chooseDataUnitLabel.text = "Choose Air Data Unit"
        case .Soil: cell.chooseDataUnitLabel.text = "Choose Soil Data Unit"
        case .Water: cell.chooseDataUnitLabel.text = "Choose Water Data Unit"
        }

      }

      cell.dataUnitLabel.isHidden = true
      cell.chooseDataUnitLabel.isHidden = false

    }

    cell.presentDataUnitChoice = presentDataUnitChoice

    return cell

  }

  private func makeDataValueChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dataValueChoice",
      for: indexPath) as! DataValueChoiceTableViewCell

    if let abioticFactorChoices = abioticFactorChoices,
       let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {

      case is DataValue:
        let value = dataValue as! DataValue
        cell.dataValueLabel.text = value.stringValue

      case is SoilPotassiumScale:
        let value = dataValue as! SoilPotassiumScale
        var text = ""
        switch value {
        case .Low(_, let label): text = label
        case .Medium(_, let label): text = label
        case .High(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      case is WaterOdorScale:
        let value = dataValue as! WaterOdorScale
        var text = ""
        switch value {
        case .NoOdor(_, let label): text = label
        case .SlightOdor(_, let label): text = label
        case .Smelly(_, let label): text = label
        case .VerySmelly(_, let label): text = label
        case .Devastating(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      case is WaterTurbidityScale:
        let value = dataValue as! WaterTurbidityScale
        var text = ""
        switch value {
        case .CrystalClear(_, let label): text = label
        case .SlightlyCloudy(_, let label): text = label
        case .ModeratelyCloudy(_, let label): text = label
        case .VeryCloudy(_, let label): text = label
        case .BlackishOrBrownish(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      default: fatalError()
      }

      cell.dataValueLabel.textColor = .black

    } else {

      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: cell.dataValueLabel.text = "Set Air Data Value"
        case .Soil: cell.dataValueLabel.text = "Set Soil Data Value"
        case .Water: cell.dataValueLabel.text = "Set Water Data Value"
        }
      }

      cell.dataValueLabel.textColor = .lightGray

    }

    cell.presentDataValueChoice = presentDataValueChoice

    return cell

  }

  private func makeSaveDataCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "saveData",
      for: indexPath) as! SaveDataTableViewCell

    cell.saveDataButton.rounded()
    cell.handleSaveData = handleSaveData

    return cell

  }

}

class DataUITableViewHeaderFooterView: UITableViewHeaderFooterView {

  static let reuseIdentifier = "tableHeader"

  let label = UILabel()

  override public init(reuseIdentifier: String?) {

    super.init(reuseIdentifier: reuseIdentifier)
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    contentView.backgroundColor = DARK_GREEN

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class DateChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!

  var presentDateChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentDateChoice()
  }

}

class DateChoiceViewController: UIViewController {

  @IBOutlet weak var datePicker: UIDatePicker!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  var dateChoice: Date!

  var handleDateChoice: ((Date) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.date = dateChoice
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      handleDateChoice(datePicker.date)
    }
    dismiss(animated: true, completion: nil)

  }

}

class TimeChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var timeLabel: UILabel!

  var presentTimeChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentTimeChoice()
  }

}

class TimeChoiceViewController: UIViewController {

  @IBOutlet weak var timePicker: UIDatePicker!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  var timeChoice: Date!

  var handleTimeChoice: ((Date) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    timePicker.date = timeChoice
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      handleTimeChoice(timePicker.date)
    }
    dismiss(animated: true, completion: nil)

  }

}

class EcoFactorChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var ecoFactorLabel: UILabel!

  var presentEcoFactorChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentEcoFactorChoice()
  }

}

class EcoFactorChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var ecoFactorPicker: UIPickerView!

  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  fileprivate var ecoFactorChoice: EcoFactor? = nil

  fileprivate var handleEcoFactorChoice: ((EcoFactor) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    ecoFactorPicker.dataSource = self
    ecoFactorPicker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let ecoFactorChoice = ecoFactorChoice {
      let selectedRow = EcoFactor.all.index(of: ecoFactorChoice)!
      ecoFactorPicker.selectRow(selectedRow, inComponent: 0, animated: false)
    } else {
      ecoFactorPicker.selectRow(0, inComponent: 0, animated: false)
    }
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = ecoFactorPicker.selectedRow(inComponent: 0)
      handleEcoFactorChoice(EcoFactor.all[selectedRow])
    }

    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return EcoFactor.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return EcoFactor.all[row].rawValue
  }

}

class AbioticFactorChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var abioticFactorLabel: UILabel!

  var presentAbioticFactorChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentAbioticFactorChoice()
  }

}

class AbioticFactorChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var abioticFactorPicker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoice: AbioticFactor? = nil

  fileprivate var handleAbioticFactorChoice: ((AbioticFactor) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    abioticFactorPicker.dataSource = self
    abioticFactorPicker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let abioticFactorChoice = abioticFactorChoice {
      let selectedRow = AbioticFactor.all.index(of: abioticFactorChoice)!
      abioticFactorPicker.selectRow(selectedRow, inComponent: 0, animated: false)
    } else {
      abioticFactorPicker.selectRow(0, inComponent: 0, animated: false)
    }
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = abioticFactorPicker.selectedRow(inComponent: 0)
      handleAbioticFactorChoice(AbioticFactor.all[selectedRow])
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return AbioticFactor.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return AbioticFactor.all[row].rawValue
  }

}

class DataTypeChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dataTypeLabel: UILabel!

  var presentDataTypeChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentDataTypeChoice()
  }

}

class DataTypeChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var dataTypePicker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleDataTypeChoice: ((DataTypeChoice) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    dataTypePicker.dataSource = self
    dataTypePicker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let dataTypeChoice = abioticFactorChoices.dataType {

      switch abioticFactorChoices.abioticFactor {

      case .Air?:
        if case let .Air(airDataType) = dataTypeChoice {
          selectedRow = AirDataType.all.index(of: airDataType)!
        }

      case .Soil?:
        if case let .Soil(soilDataType) = dataTypeChoice {
          selectedRow = SoilDataType.all.index(of: soilDataType)!
        }

      case .Water?:
        if case let .Water(waterDataType) = dataTypeChoice {
          selectedRow = WaterDataType.all.index(of: waterDataType)!
        }

      default: break

      }
    }

    dataTypePicker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = dataTypePicker.selectedRow(inComponent: 0)
      switch abioticFactorChoices.abioticFactor {

      case .Air?: handleDataTypeChoice(.Air(AirDataType.all[selectedRow]))

      case .Soil?: handleDataTypeChoice(.Soil(SoilDataType.all[selectedRow]))

      case .Water?: handleDataTypeChoice(.Water(WaterDataType.all[selectedRow]))

      default: break

      }
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

    switch abioticFactorChoices.abioticFactor {

    case .Air?: return AirDataType.all.count

    case .Soil?: return SoilDataType.all.count

    case .Water?: return WaterDataType.all.count

    default: return 0

    }

  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch abioticFactorChoices.abioticFactor {

    case .Air?: return AirDataType.all[row].rawValue

    case .Soil?: return SoilDataType.all[row].rawValue

    case .Water?: return WaterDataType.all[row].rawValue

    default: return nil

    }

  }

}

class DataUnitChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dataUnitView: UIView!

  @IBOutlet weak var chooseDataUnitLabel: UILabel!

  var dataUnitLabel: MTMathUILabel = MTMathUILabel()

  var presentDataUnitChoice: (() -> Void)!

  override func layoutSubviews() {

    if dataUnitView.subviews.index(of: dataUnitLabel) == nil {
      dataUnitView.addSubview(dataUnitLabel)
      dataUnitLabel.textAlignment = .left
      dataUnitLabel.fontSize = 25
      dataUnitLabel.textColor = .black
      dataUnitLabel.frame.size = dataUnitView.frame.size
    }

    super.layoutSubviews()

  }

  @IBAction func touchUpInside() {
    presentDataUnitChoice()
  }

}

class DataUnitChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var dataUnitPicker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleDataUnitChoice: ((DataUnitChoice) -> Void)!

  private var dataUnits: [DataUnitChoice] = []

  override func viewDidLoad() {

    super.viewDidLoad()

    dataUnitPicker.dataSource = self
    dataUnitPicker.delegate = self

    if let dataType = abioticFactorChoices.dataType {
      dataUnits = DataUnitChoice.units(dataType)
    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let dataUnitChoice = abioticFactorChoices.dataUnit {
      selectedRow = dataUnits.index(of: dataUnitChoice)!
    }

    dataUnitPicker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = dataUnitPicker.selectedRow(inComponent: 0)
      handleDataUnitChoice(dataUnits[selectedRow])
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return dataUnits.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return dataUnits[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView,
                  viewForRow row: Int,
                  forComponent component: Int,
                  reusing view: UIView?) -> UIView {

    let label = MTMathUILabel()
    label.latex = dataUnits[row].rawValue
    label.textAlignment = .center
    label.fontSize = 25
    return label

  }

  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 75
  }

}

class DataValueChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dataValueLabel: UILabel!

  var presentDataValueChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentDataValueChoice()
  }

}

class DataValueChoiceViewController: UIViewController {

  @IBOutlet weak var valueLabel: UILabel!

  @IBOutlet weak var clearButton: UIButton!

  @IBOutlet weak var signButton: UIButton!

  @IBOutlet weak var deleteButton: UIButton!

  @IBOutlet weak var zeroButton: UIButton!

  @IBOutlet weak var oneButton: UIButton!

  @IBOutlet weak var twoButton: UIButton!

  @IBOutlet weak var threeButton: UIButton!

  @IBOutlet weak var fourButton: UIButton!

  @IBOutlet weak var fiveButton: UIButton!

  @IBOutlet weak var sixButton: UIButton!

  @IBOutlet weak var sevenButton: UIButton!

  @IBOutlet weak var eightButton: UIButton!

  @IBOutlet weak var nineButton: UIButton!

  @IBOutlet weak var decimalButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  private var dataValue: DataValue = DataValue()

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleDataValueChoice: ((DataValue) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()

    valueLabel.roundedAndDarkBordered()

    clearButton.roundedAndDarkBordered()
    signButton.roundedAndDarkBordered()
    deleteButton.roundedAndDarkBordered()
    decimalButton.roundedAndDarkBordered()
    okButton.roundedAndDarkBordered()

    zeroButton.roundedAndDarkBordered()
    oneButton.roundedAndDarkBordered()
    twoButton.roundedAndDarkBordered()
    threeButton.roundedAndDarkBordered()
    fourButton.roundedAndDarkBordered()
    fiveButton.roundedAndDarkBordered()
    sixButton.roundedAndDarkBordered()
    sevenButton.roundedAndDarkBordered()
    eightButton.roundedAndDarkBordered()
    nineButton.roundedAndDarkBordered()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let dataValue = abioticFactorChoices.dataValue as? DataValue {
      self.dataValue = dataValue
      valueLabel.text = dataValue.stringValue
    }

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    var newDataValue: DataValue? = nil

    switch sender {

    case clearButton:
      newDataValue = DataValue()

    case signButton:
      newDataValue = dataValue.toggleSign()

    case deleteButton:
      newDataValue = dataValue.deleteDigit()

    case decimalButton:
      newDataValue = dataValue.addDecimalPoint()

    case zeroButton:
      newDataValue = dataValue.addDigit(0)

    case oneButton:
      newDataValue = dataValue.addDigit(1)

    case twoButton:
      newDataValue = dataValue.addDigit(2)

    case threeButton:
      newDataValue = dataValue.addDigit(3)

    case fourButton:
      newDataValue = dataValue.addDigit(4)

    case fiveButton:
      newDataValue = dataValue.addDigit(5)

    case sixButton:
      newDataValue = dataValue.addDigit(6)

    case sevenButton:
      newDataValue = dataValue.addDigit(7)

    case eightButton:
      newDataValue = dataValue.addDigit(8)

    case nineButton:
      newDataValue = dataValue.addDigit(9)

    case okButton:
      handleDataValueChoice(dataValue)
      dismiss(animated: true, completion: nil)

    case cancelButton:
      dismiss(animated: true, completion: nil)

    default:
      LOG.error("Unexpected button \(sender)")

    }

    if let newDataValue = newDataValue,
       newDataValue.stringValue.count <= 10 {

      dataValue = newDataValue
      valueLabel.text = dataValue.stringValue

    }

  }

}

class PhValueChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var pHValuePicker: UIPickerView!

  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleDataValueChoice: ((DataValue) -> Void)!

  private let numberRange = Array(1...14)

  private let fractionRange = Array(0...9)

  override func viewDidLoad() {
    super.viewDidLoad()
    pHValuePicker.dataSource = self
    pHValuePicker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var numberRow: Int = 0
    var fractionRow: Int = 0
    if let dataValue = abioticFactorChoices.dataValue as? DataValue {
      numberRow = numberRange.index(of: Int(dataValue.number)!)!
      if let fraction = dataValue.fraction {
        fractionRow = fractionRange.index(of: Int(fraction)!)!
      }
    }

    pHValuePicker.selectRow(numberRow, inComponent: 0, animated: false)
    pHValuePicker.selectRow(fractionRow, inComponent: 2, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {

      let number = Int(pHValuePicker.selectedRow(inComponent: 0) + 1)
      let fraction = Int(pHValuePicker.selectedRow(inComponent: 2))
      if number == 14 {
        handleDataValueChoice(DataValue(number: String(number), fraction: "0"))
      } else {
        handleDataValueChoice(DataValue(number: String(number), fraction: String(fraction)))
      }

    }

    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

    if component == 0 {
      return 14
    } else if component == 1 {
      return 1
    } else {
      return 10
    }

  }

  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

    if component == 1 {
      return 20
    } else {
      return 100
    }

  }

  func pickerView(_ pickerView: UIPickerView,
                  viewForRow row: Int,
                  forComponent component: Int,
                  reusing view: UIView?) -> UIView {

    let label = UILabel()
    if component == 0 {
      label.text = String(row + 1)
      label.textAlignment = .right
    } else if component == 1 {
      label.text = "."
      label.textAlignment = .center
    } else {
      label.text = String(row)
      label.textAlignment = .left
    }

    return label

  }

}

class SoilPotassiumChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var picker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleSoilPotassiumChoice: ((SoilPotassiumScale) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let soilPotassiumScale = abioticFactorChoices.dataValue as? SoilPotassiumScale {
      switch soilPotassiumScale {
      case let .Low(index, _): selectedRow = index
      case let .Medium(index, _): selectedRow = index
      case let .High(index, _): selectedRow = index
      }
    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleSoilPotassiumChoice(SoilPotassiumScale.all[selectedRow])
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return SoilPotassiumScale.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch SoilPotassiumScale.all[row] {
    case let .Low(_, label): return label
    case let .Medium(_, label): return label
    case let .High(_, label): return label
    }

  }

}

class WaterOdorChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var picker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleWaterOdorChoice: ((WaterOdorScale) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let waterOdorScale = abioticFactorChoices.dataValue as? WaterOdorScale {
      switch waterOdorScale {
      case let .NoOdor(index, _): selectedRow = index
      case let .SlightOdor(index, _): selectedRow = index
      case let .Smelly(index, _): selectedRow = index
      case let .VerySmelly(index, _): selectedRow = index
      case let .Devastating(index, _): selectedRow = index
      }
    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleWaterOdorChoice(WaterOdorScale.all[selectedRow])
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return WaterOdorScale.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch WaterOdorScale.all[row] {
    case let .NoOdor(_, label): return label
    case let .SlightOdor(_, label): return label
    case let .Smelly(_, label): return label
    case let .VerySmelly(_, label): return label
    case let .Devastating(_, label): return label
    }

  }

}

class WaterTurbidityChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var picker: UIPickerView!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleWaterTurbidityChoice: ((WaterTurbidityScale) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let waterTurbidityScale = abioticFactorChoices.dataValue as? WaterTurbidityScale {
      switch waterTurbidityScale {
      case let .CrystalClear(index, _): selectedRow = index
      case let .SlightlyCloudy(index, _): selectedRow = index
      case let .ModeratelyCloudy(index, _): selectedRow = index
      case let .VeryCloudy(index, _): selectedRow = index
      case let .BlackishOrBrownish(index, _): selectedRow = index
      }
    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleWaterTurbidityChoice(WaterTurbidityScale.all[selectedRow])
    }
    dismiss(animated: true, completion: nil)

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return WaterTurbidityScale.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch WaterTurbidityScale.all[row] {
    case let .CrystalClear(_, label): return label
    case let .SlightlyCloudy(_, label): return label
    case let .ModeratelyCloudy(_, label): return label
    case let .VeryCloudy(_, label): return label
    case let .BlackishOrBrownish(_, label): return label
    }

  }

}

class SaveDataTableViewCell: UITableViewCell {

  @IBOutlet weak var saveDataButton: UIButton!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var handleSaveData: (() -> Void)!

  @IBAction func touchUpInside() {
    activityIndicator.startAnimating()
    handleSaveData()
  }

}

