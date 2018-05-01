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

  case PartsPerMillion = "ppm (Parts Per Million)"
  case Lux
  case PhotosyntheticPhotonFluxDensity = "PPFD (Photosynthetic Photon Flux Density)"
  case MicromolesPerMetersSquaredAndSeconds = "µmol m^-2 s^-1"
  case Percent = "%"
  case DegreesCelsius = "°C"
  case DegreesFahrenheit = "°F"
  case MegawattsPerMeterSquared = "mW/m^2"
  case MetersPerSecond = "m/s"
  case MilesPerHour = "mph"
  case PoundsPerAcre = "lb/a"
  case MicrosiemensPerCentimeter = "µS/cm"
  case FeetPerSecond = "ft/s"
  case MilligramsPerLiter = "mg/L"
  case NephelometricTurbidityUnits = "NTU (Nephelometric Turbidity Units)"
  case JacksonTurbidityUnits = "JTU (Jackson Turbidity Units)"
  case _Scale_

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
        ._Scale_
      ]

    case .Soil(let soilDataType) where soilDataType == .Moisture:
      return [
        .Percent
      ]

    case .Soil(let soilDataType) where soilDataType == .Texture:
      return [
        ._Scale_
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
        ._Scale_
      ]

    case .Water(let waterDataType) where waterDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]

    case .Water(let waterDataType) where waterDataType == .pH:
      return [
        ._Scale_
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
        ._Scale_
      ]

    default: return []

    }

  }

}

fileprivate struct AbioticFactorChoices {

  let abioticFactor: AbioticFactor?
  let dataType: DataTypeChoice?
  let dataUnit: DataUnitChoice?
  let dataValue: Double?

  init(abioticFactor: AbioticFactor? = nil,
       dataType: DataTypeChoice? = nil,
       dataUnit: DataUnitChoice? = nil,
       dataValue: Double? = nil) {
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
    formatter.dateFormat = "h:mm a"
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
    performSegue(withIdentifier: "dataValueChoice", sender: nil)
  }

  fileprivate func handleDataValueChoice(_ dataValueChoice: Double) {

    if let abioticFactorChoices = abioticFactorChoices,
       dataValueChoice == abioticFactorChoices.dataValue {
      return
    }

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: abioticFactorChoices.dataType,
        dataValue: dataValueChoice)
    }
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

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

    switch section {

    case 0: return "Date"

    case 1: return "Time"

    case 2: return "Ecosystem Factor"

    case 3:
      if abioticFactorChoices != nil {
        return "Abiotic Factor"
      }
      if bioticFactorChoices != nil {
        return "Biotic Factor"
      }
      return nil

    case 4:
      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: return "Air Data Type"
        case .Soil: return "Soil Data Type"
        case .Water: return "Water Data Type"
        }
      }
      return nil

    case 5:
      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: return "Air Data Unit"
        case .Soil: return "Soil Data Unit"
        case .Water: return "Water Data Unit"
        }
      }
      return nil

    case 6:
      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: return "Air Data Value"
        case .Soil: return "Soil Data Value"
        case .Water: return "Water Data Value"
        }
      }
      return nil

    default: return nil

    }

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

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dataUnitChoice",
      for: indexPath) as! DataUnitChoiceTableViewCell

    if let abioticFactorChoices = abioticFactorChoices,
       let dataUnit = abioticFactorChoices.dataUnit {

      cell.dataUnitLabel.text = dataUnit.rawValue
      cell.dataUnitLabel.textColor = .black

    } else {

      if let abioticFactorChoices = abioticFactorChoices,
         let abioticFactor = abioticFactorChoices.abioticFactor {
        switch abioticFactor {
        case .Air: cell.dataUnitLabel.text = "Choose Air Data Unit"
        case .Soil: cell.dataUnitLabel.text = "Choose Soil Data Unit"
        case .Water: cell.dataUnitLabel.text = "Choose Water Data Unit"
        }
      }

      cell.dataUnitLabel.textColor = .lightGray

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

      cell.dataValueLabel.text = String(dataValue)
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

class DateChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!

  var presentDateChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentDateChoice()
  }

}

class DateChoiceViewController: UIViewController {

  @IBOutlet weak var datePicker: UIDatePicker!

  var dateChoice: Date!

  var handleDateChoice: ((Date) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.date = dateChoice
  }

  @IBAction func touchUpInside() {
    handleDateChoice(datePicker.date)
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

  var timeChoice: Date!

  var handleTimeChoice: ((Date) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    timePicker.date = timeChoice
  }

  @IBAction func touchUpInside() {
    handleTimeChoice(timePicker.date)
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

  @IBAction func touchUpInside() {
    let selectedRow = ecoFactorPicker.selectedRow(inComponent: 0)
    handleEcoFactorChoice(EcoFactor.all[selectedRow])
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

  @IBAction func touchUpInside() {
    let selectedRow = abioticFactorPicker.selectedRow(inComponent: 0)
    handleAbioticFactorChoice(AbioticFactor.all[selectedRow])
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

  @IBAction func touchUpInside() {
    let selectedRow = dataTypePicker.selectedRow(inComponent: 0)
    switch abioticFactorChoices.abioticFactor {

    case .Air?: handleDataTypeChoice(.Air(AirDataType.all[selectedRow]))

    case .Soil?: handleDataTypeChoice(.Soil(SoilDataType.all[selectedRow]))

    case .Water?: handleDataTypeChoice(.Water(WaterDataType.all[selectedRow]))

    default: break

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

  @IBOutlet weak var dataUnitLabel: UILabel!

  var presentDataUnitChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentDataUnitChoice()
  }

}

class DataUnitChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var dataUnitPicker: UIPickerView!

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

  @IBAction func touchUpInside() {
    let selectedRow = dataUnitPicker.selectedRow(inComponent: 0)
    handleDataUnitChoice(dataUnits[selectedRow])
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

  private var value: String = "0"

  fileprivate var abioticFactorChoices: AbioticFactorChoices!

  fileprivate var handleDataValueChoice: ((Double) -> Void)!

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

    if let dataValue = abioticFactorChoices.dataValue {
      value = String(dataValue)
      valueLabel.text = "\(value)"
    }

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    var newValue = value

    switch sender {

    case clearButton:
      newValue = "0"

    case signButton:
      let doubleValue = Double(newValue)!
      if doubleValue != 0.0 {
        newValue = "\(-Double(newValue)!)"
      }

    case deleteButton:
      if newValue.count > 0 {
        let beforeEndIndex = newValue.index(before: newValue.endIndex)
        newValue = String(value[..<beforeEndIndex])
        if newValue.isEmpty {
          newValue = "0"
        }
      }

    case decimalButton:
      if !newValue.contains(".") {
        newValue = newValue + "."
      }

    case zeroButton:
      if newValue == "0" {
        return
      } else {
        newValue = newValue + "0"
      }

    case oneButton:
      if newValue == "0" {
        newValue = "1"
      } else {
        newValue = newValue + "1"
      }

    case twoButton:
      if newValue == "0" {
        newValue = "2"
      } else {
        newValue = newValue + "2"
      }

    case threeButton:
      if newValue == "0" {
        newValue = "3"
      } else {
        newValue = newValue + "3"
      }

    case fourButton:
      if newValue == "0" {
        newValue = "4"
      } else {
        newValue = newValue + "4"
      }

    case fiveButton:
      if newValue == "0" {
        newValue = "5"
      } else {
        newValue = newValue + "5"
      }

    case sixButton:
      if newValue == "0" {
        newValue = "6"
      } else {
        newValue = newValue + "6"
      }

    case sevenButton:
      if newValue == "0" {
        newValue = "7"
      } else {
        newValue = newValue + "7"
      }

    case eightButton:
      if newValue == "0" {
        newValue = "8"
      } else {
        newValue = newValue + "8"
      }

    case nineButton:
      if newValue == "0" {
        newValue = "9"
      } else {
        newValue = newValue + "9"
      }

    case okButton:
      handleDataValueChoice(Double(value)!)
      dismiss(animated: true, completion: nil)

    default:
      LOG.error("Unexpected button \(sender)")

    }

    if newValue.count <= 10 {
      value = newValue
      valueLabel.text = "\(value)"
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
