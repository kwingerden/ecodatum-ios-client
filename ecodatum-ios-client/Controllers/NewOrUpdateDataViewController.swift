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

  case Anemometer
  case CarbonDioxide = "Carbon Dioxide"
  case Light
  case PAR
  case RelativeHumidity = "Relative Humidity"
  case Temperature
  case UVB

  static let all: [AirDataType] = [
    .Anemometer,
    .CarbonDioxide,
    .Light,
    .PAR,
    .RelativeHumidity,
    .Temperature,
    .UVB
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

}

fileprivate struct AbioticFactorChoices {

  let abioticFactor: AbioticFactor
  let dataType: DataTypeChoice?

}

fileprivate struct BioticFactorChoices {

  let bioticFactor: BioticFactor
  
}

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var saveButton: UIButton!

  private var dateChoice: Date = Date()

  private var timeChoice: Date = Date()

  private var ecoFactorChoice: EcoFactor? = nil

  private var abioticFactorChoices: AbioticFactorChoices? = nil

  private var bioticFactorChoices: BioticFactorChoices? = nil

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

    saveButton.rounded()

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

    self.ecoFactorChoice = ecoFactor
    tableView.reloadSections([3], with: .automatic)
    tableView.insertSections([4], with: .automatic)

  }

  func presentAbioticFactorChoice() {
    performSegue(withIdentifier: "abioticFactorChoice", sender: nil)
  }

  fileprivate func handleAbioticFactorChoice(_ abioticFactor: AbioticFactor) {

    self.abioticFactorChoices = AbioticFactorChoices(
      abioticFactor: abioticFactor,
      dataType: nil)
    tableView.reloadSections([4], with: .automatic)

  }

  func presentDataTypeChoice() {
    performSegue(withIdentifier: "dataTypeChoice", sender: nil)
  }

  fileprivate func handleDataTypeChoice(_ dataTypeChoice: DataTypeChoice) {

    if let abioticFactorChoices = abioticFactorChoices {
      self.abioticFactorChoices = AbioticFactorChoices(
        abioticFactor: abioticFactorChoices.abioticFactor,
        dataType: dataTypeChoice)
    }

    tableView.reloadSections([4], with: .automatic)

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
      if abioticFactorChoices != nil { return "Abiotic Factor"}
      if bioticFactorChoices != nil { return "Biotic Factor"}
      return nil
    case 4:
      if abioticFactorChoices != nil { return "Data Type"}
      return nil
    default: return nil

    }

  }

  func numberOfSections(in tableView: UITableView) -> Int {

    if ecoFactorChoice == nil {

      return 3

    } else if let abioticFactorChoices = abioticFactorChoices {

      if abioticFactorChoices.dataType == nil {
        return 4
      } else {
        return 5
      }

    } else if let bioticFactorChoices = bioticFactorChoices {

      return 3

    }

    return 3

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.section {

    case 0: return makeDateChoiceCell(tableView, indexPath)
    case 1: return makeTimeChoiceCell(tableView, indexPath)
    case 2: return makeEcoFactorChoiceCell(tableView, indexPath)
    case 3: return makeAbioticFactorChoiceCell(tableView, indexPath)
    case 4: return makeDataTypeChoiceCell(tableView, indexPath)
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

    if let abioticFactorChoices = abioticFactorChoices {

      cell.abioticFactorLabel.text = abioticFactorChoices.abioticFactor.rawValue
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

      //cell.dataTypeLabel.text = dataType.rawValue
      cell.dataTypeLabel.textColor = .black

    } else {

      cell.dataTypeLabel.text = "Choose Data Typ"
      cell.dataTypeLabel.textColor = .lightGray

    }

    //cell.presentDataTypeChoice = presentAbioticFactorChoice

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

      case .Air:
        if case let .Air(airDataType) = dataTypeChoice {
          selectedRow = AirDataType.all.index(of: airDataType)!
        }

      case .Soil:
        if case let .Soil(soilDataType) = dataTypeChoice {
          selectedRow = SoilDataType.all.index(of: soilDataType)!
        }

      case .Water:
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

    case .Air: handleDataTypeChoice(.Air(AirDataType.all[selectedRow]))

    case .Soil: handleDataTypeChoice(.Soil(SoilDataType.all[selectedRow]))

    case .Water: handleDataTypeChoice(.Water(WaterDataType.all[selectedRow]))

    default: break

    }
    dismiss(animated: true, completion: nil)
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

    switch abioticFactorChoices.abioticFactor {

    case .Air: return AirDataType.all.count

    case .Soil: return SoilDataType.all.count

    case .Water: return WaterDataType.all.count

    default: return 0

    }

  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch abioticFactorChoices.abioticFactor {

    case .Air: return AirDataType.all[row].rawValue

    case .Soil: return SoilDataType.all[row].rawValue

    case .Water: return WaterDataType.all[row].rawValue

    default: return nil

    }

  }

}



