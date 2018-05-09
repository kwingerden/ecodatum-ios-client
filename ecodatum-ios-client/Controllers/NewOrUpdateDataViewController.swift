import Foundation
import SwiftValidator
import UIKit
import WebKit

typealias DataValueHandler = (DataValue) -> Void

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var tableView: UITableView!

  private var ecoData: EcoDatum = EcoDatum()

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
          destination.dateChoice = ecoData.date
          destination.handleDateChoice = handleDateChoice
        }

      case "timeChoice":
        if let destination = segue.destination as? TimeChoiceViewController {
          destination.timeChoice = ecoData.time
          destination.handleTimeChoice = handleTimeChoice
        }

      case "ecoFactorChoice":
        if let destination = segue.destination as? EcoFactorChoiceViewController {
          destination.ecoFactorChoice = ecoData.ecoFactor
          destination.handleEcoFactorChoice = handleEcoFactorChoice
        }

      case "abioticFactorChoice":
        if let destination = segue.destination as? AbioticFactorChoiceViewController {
          destination.abioticFactorChoice = ecoData.abioticFactor
          destination.handleAbioticFactorChoice = handleAbioticFactorChoice
        }

      case "dataTypeChoice":
        if let destination = segue.destination as? DataTypeChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataTypeChoice = handleDataTypeChoice
        }

      case "dataUnitChoice":
        if let destination = segue.destination as? DataUnitChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataUnitChoice = handleDataUnitChoice
        }

      case "dataValueChoice":
        if let destination = segue.destination as? DataValueChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataValueChoice = handleDataValueChoice
        }

      case "pHValueChoice":
        if let destination = segue.destination as? PhValueChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleDataValueChoice = handleDataValueChoice
        }

      case "soilPotassiumChoice":
        if let destination = segue.destination as? SoilPotassiumChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleSoilPotassiumChoice = handleDataValueChoice
        }

      case "waterOdorChoice":
        if let destination = segue.destination as? WaterOdorChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleWaterOdorChoice = handleDataValueChoice
        }

      case "waterTurbidityChoice":
        if let destination = segue.destination as? WaterTurbidityChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleWaterTurbidityChoice = handleDataValueChoice
        }

      case "soilTextureChoice":
        if let destination = segue.destination as? SoilTextureChoiceViewController,
           let abioticFactorChoices = ecoData.abioticEcoData {
          destination.abioticFactorChoices = abioticFactorChoices
          destination.handleSoilTextureChoice = handleDataValueChoice
        }

      case "imageChoice":
        if let destination = segue.destination as? ImageChoiceViewController,
           let bioticFactorChoices = ecoData.bioticEcoData {
          destination.bioticFactorChoices = bioticFactorChoices
          destination.handleImageChoice = handleImageChoice
        }

      case "notesChoice":
        if let destination = segue.destination as? NotesChoiceViewController,
           let bioticFactorChoices = ecoData.bioticEcoData {
          destination.bioticFactorChoices = bioticFactorChoices
          destination.handleNotesChoice = handleNotesChoice
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

    ecoData = ecoData.new(date: date)
    tableView.reloadSections([0], with: .automatic)

  }

  func presentTimeChoice() {
    performSegue(withIdentifier: "timeChoice", sender: nil)
  }

  func handleTimeChoice(_ date: Date) {

    ecoData = ecoData.new(time: date)
    tableView.reloadSections([1], with: .automatic)

  }

  func presentEcoFactorChoice() {
    performSegue(withIdentifier: "ecoFactorChoice", sender: nil)
  }

  func handleEcoFactorChoice(_ ecoFactor: EcoFactor) {

    if ecoData.ecoFactor == ecoFactor {
      return
    }

    ecoData = ecoData.new(ecoFactor: ecoFactor)
    tableView.reloadSections([2], with: .automatic)

    if ecoFactor == .Abiotic {
      ecoData = ecoData.new(data: .Abiotic(AbioticEcoData()))
    } else {
      ecoData = ecoData.new(data: .Biotic(BioticEcoData()))
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

  func handleAbioticFactorChoice(_ abioticFactor: AbioticFactor) {

    switch ecoData.data {
    case .Abiotic(let abioticEcoData)?:
      ecoData = ecoData.new(data: .Abiotic(abioticEcoData.new(abioticFactor: abioticFactor)))
    default: fatalError()
    }

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

  func handleDataTypeChoice(_ abioticDataType: AbioticDataTypeChoice) {

    switch ecoData.data {
    case .Abiotic(let abioticEcoData)?:
      ecoData = ecoData.new(data: .Abiotic(abioticEcoData.new(dataType: abioticDataType)))
    default: fatalError()
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

  func handleDataUnitChoice(_ dataUnitChoice: AbioticDataUnitChoice) {

    switch ecoData.data {
    case .Abiotic(let abioticEcoData)?:
      ecoData = ecoData.new(data: .Abiotic(abioticEcoData.new(dataUnit: dataUnitChoice)))
    default: fatalError()
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

    switch ecoData.abioticEcoData?.dataUnit {

    case ._Water_pH_Scale_?:
      performSegue(withIdentifier: "pHValueChoice", sender: nil)

    case ._Soil_Potassium_Scale_?:
      performSegue(withIdentifier: "soilPotassiumChoice", sender: nil)

    case ._Water_Odor_Scale_?:
      performSegue(withIdentifier: "waterOdorChoice", sender: nil)

    case ._Water_Turbidity_Scale_?:
      performSegue(withIdentifier: "waterTurbidityChoice", sender: nil)

    case ._Soil_Texture_Scale_?:
      performSegue(withIdentifier: "soilTextureChoice", sender: nil)

    default:
      performSegue(withIdentifier: "dataValueChoice", sender: nil)

    }

  }

  func handleDataValueChoice(_ dataValue: DataValue) {

    switch ecoData.data {
    case .Abiotic(let abioticEcoData)?:
      ecoData = ecoData.new(data: .Abiotic(abioticEcoData.new(dataValue: dataValue)))
    default: fatalError()
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

  func presentImageChoice() {
    performSegue(withIdentifier: "imageChoice", sender: nil)
  }

  func handleImageChoice(_ image: UIImage) {

    switch ecoData.data {
    case .Biotic(let bioticEcoData)?:
      ecoData = ecoData.new(data: .Biotic(bioticEcoData.new(image: image)))
    default: fatalError()
    }

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

  func presentNotesChoice() {
    performSegue(withIdentifier: "notesChoice", sender: nil)
  }

  func handleNotesChoice(_ notes: NSAttributedString) {

    switch ecoData.data {
    case .Biotic(let bioticEcoData)?:
      ecoData = ecoData.new(data: .Biotic(bioticEcoData.new(notes: notes)))
    default: fatalError()
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

  func handleSaveData() {
    viewControllerManager.newOrUpdateEcoDatum(ecoDatum: ecoData)
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

    switch ecoData.ecoFactor {

    case .Abiotic? where indexPath.section == 5: // Abiotic -> Data Unit
      return 82

    case .Abiotic? where indexPath.section == 7: // Abiotic -> Save Button
      return 115

    case .Biotic? where indexPath.section == 3: // Biotic -> Photo
      return 250

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

    case 3:
      switch ecoData.ecoFactor {
      case .Abiotic?: return makeAbioticFactorChoiceCell(tableView, indexPath)
      case .Biotic?: return makeImageChoiceCell(tableView, indexPath)
      default: fatalError()
      }

    case 4:
      switch ecoData.ecoFactor {
      case .Abiotic?: return makeDataTypeChoiceCell(tableView, indexPath)
      case .Biotic?: return makeNotesChoiceCell(tableView, indexPath)
      default: fatalError()
      }

    case 5:
      switch ecoData.ecoFactor {
      case .Abiotic?: return makeDataUnitChoiceCell(tableView, indexPath)
      case .Biotic?: return makeSaveDataCell(tableView, indexPath)
      default: fatalError()
      }

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

    cell.dateLabel.text = DATE_FORMATTER.string(from: ecoData.date)
    cell.presentDateChoice = presentDateChoice

    return cell

  }

  private func makeTimeChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "timeChoice",
      for: indexPath) as! TimeChoiceTableViewCell

    cell.timeLabel.text = TIME_FORMATTER.string(from: ecoData.time)
    cell.presentTimeChoice = presentTimeChoice

    return cell

  }

  private func makeEcoFactorChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ecoFactorChoice",
      for: indexPath) as! EcoFactorChoiceTableViewCell

    if let ecoFactor = ecoData.ecoFactor {

      cell.ecoFactorLabel.text = ecoFactor.rawValue
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

    if let abioticFactor = ecoData.abioticFactor {

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

    if let dataType = ecoData.abioticEcoData?.dataType {

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

      switch ecoData.abioticFactor {
      case .Air?: cell.dataTypeLabel.text = "Choose Air Data Type"
      case .Soil?: cell.dataTypeLabel.text = "Choose Soil Data Type"
      case .Water?: cell.dataTypeLabel.text = "Choose Water Data Type"
      default: fatalError()
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

    if let dataUnit = ecoData.abioticEcoData?.dataUnit {

      cell.dataUnitLabel.latex = dataUnit.rawValue
      cell.dataUnitLabel.isHidden = false
      cell.chooseDataUnitLabel.isHidden = true

    } else {

      switch ecoData.abioticFactor {
      case .Air?: cell.chooseDataUnitLabel.text = "Choose Air Data Unit"
      case .Soil?: cell.chooseDataUnitLabel.text = "Choose Soil Data Unit"
      case .Water?: cell.chooseDataUnitLabel.text = "Choose Water Data Unit"
      default: fatalError()
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

    if let dataValue = ecoData.abioticEcoData?.dataValue {

      switch dataValue {

      case .DecimalDataValue(let decimalDataValue):
        cell.dataValueLabel.text = decimalDataValue.description

      case .SoilPotassiumScale(let soilPotassiumScale):
        var text = ""
        switch soilPotassiumScale {
        case .Low(_, let label): text = label
        case .Medium(_, let label): text = label
        case .High(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      case .WaterOdorScale(let waterOdorScale):
        var text = ""
        switch waterOdorScale {
        case .NoOdor(_, let label): text = label
        case .SlightOdor(_, let label): text = label
        case .Smelly(_, let label): text = label
        case .VerySmelly(_, let label): text = label
        case .Devastating(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      case .WaterTurbidityScale(let waterTurbidityScale):
        var text = ""
        switch waterTurbidityScale {
        case .CrystalClear(_, let label): text = label
        case .SlightlyCloudy(_, let label): text = label
        case .ModeratelyCloudy(_, let label): text = label
        case .VeryCloudy(_, let label): text = label
        case .BlackishOrBrownish(_, let label): text = label
        }
        cell.dataValueLabel.text = text

      case .SoilTextureScale(let soilTextureScale):
        cell.dataValueLabel.text =
          "\(soilTextureScale.percentSand)% Sand, " +
            "\(soilTextureScale.percentSilt)% Silt, " +
            "\(soilTextureScale.percentClay)% Clay"

      }

      cell.dataValueLabel.textColor = .black

    } else {

      switch ecoData.abioticFactor {
      case .Air?: cell.dataValueLabel.text = "Set Air Data Value"
      case .Soil?: cell.dataValueLabel.text = "Set Soil Data Value"
      case .Water?: cell.dataValueLabel.text = "Set Water Data Value"
      default: fatalError()
      }

      cell.dataValueLabel.textColor = .lightGray

    }

    cell.presentDataValueChoice = presentDataValueChoice

    return cell

  }

  private func makeImageChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "imageChoice",
      for: indexPath) as! ImageChoiceTableViewCell

    if let image = ecoData.bioticEcoData?.image {
      cell.imageView?.image = image
    } else {
      cell.imageView?.image = UIImage(named: "PlaceholderImage")
    }

    cell.presentImageChoice = presentImageChoice

    return cell

  }

  private func makeNotesChoiceCell(
    _ tableView: UITableView,
    _ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: "notesChoice",
      for: indexPath) as! NotesChoiceTableViewCell

    if let notes = ecoData.bioticEcoData?.notes {
      cell.label.attributedText = notes
      cell.label.textColor = .black
    } else {
      cell.label.text = "Add Notes"
      cell.label.textColor = .lightGray
    }

    cell.presentNotesChoice = presentNotesChoice

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

  var ecoFactorChoice: EcoFactor? = nil

  var handleEcoFactorChoice: ((EcoFactor) -> Void)!

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

  var abioticFactorChoice: AbioticFactor? = nil

  var handleAbioticFactorChoice: ((AbioticFactor) -> Void)!

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

  var abioticFactorChoices: AbioticEcoData!

  var handleDataTypeChoice: ((AbioticDataTypeChoice) -> Void)!

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

  var abioticFactorChoices: AbioticEcoData!

  var handleDataUnitChoice: ((AbioticDataUnitChoice) -> Void)!

  private var dataUnits: [AbioticDataUnitChoice] = []

  override func viewDidLoad() {

    super.viewDidLoad()

    dataUnitPicker.dataSource = self
    dataUnitPicker.delegate = self

    if let dataType = abioticFactorChoices.dataType {
      dataUnits = AbioticDataUnitChoice.units(dataType)
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

  private var dataValue: DecimalDataValue = DecimalDataValue()

  var abioticFactorChoices: AbioticEcoData!

  var handleDataValueChoice: DataValueHandler!

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
      switch dataValue {
      case .DecimalDataValue(let decimalDataValue):
        self.dataValue = decimalDataValue
        valueLabel.text = decimalDataValue.description
      default: fatalError()
      }
    }

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    var newDataValue: DecimalDataValue? = nil

    switch sender {

    case clearButton:
      newDataValue = DecimalDataValue()

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
      handleDataValueChoice(DataValue.DecimalDataValue(dataValue))
      dismiss(animated: true, completion: nil)

    case cancelButton:
      dismiss(animated: true, completion: nil)

    default:
      LOG.error("Unexpected button \(sender)")

    }

    if let newDataValue = newDataValue,
       newDataValue.description.count <= 10 {

      dataValue = newDataValue
      valueLabel.text = dataValue.description

    }

  }

}

class PhValueChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var pHValuePicker: UIPickerView!

  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  var abioticFactorChoices: AbioticEcoData!

  var handleDataValueChoice: DataValueHandler!

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
    if let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {
      case .DecimalDataValue(let decimalDataValue):
        numberRow = numberRange.index(of: Int(decimalDataValue.number)!)!
        if let fraction = decimalDataValue.fraction {
          fractionRow = fractionRange.index(of: Int(fraction)!)!
        }
      default: fatalError()
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
        let dataValue = DataValue.DecimalDataValue(DecimalDataValue(number: String(number), fraction: "0"))
        handleDataValueChoice(dataValue)
      } else {
        let dataValue = DataValue.DecimalDataValue(DecimalDataValue(number: String(number), fraction: String(fraction)))
        handleDataValueChoice(dataValue)
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

  var abioticFactorChoices: AbioticEcoData!

  var handleSoilPotassiumChoice: DataValueHandler!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {
      case .SoilPotassiumScale(let soilPotassiumScale):
        switch soilPotassiumScale {
        case let .Low(index, _): selectedRow = index
        case let .Medium(index, _): selectedRow = index
        case let .High(index, _): selectedRow = index
        }
      default: fatalError()
      }

    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleSoilPotassiumChoice(
        DataValue.SoilPotassiumScale(
          SoilPotassiumScale.all[selectedRow]))
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

  var abioticFactorChoices: AbioticEcoData!

  var handleWaterOdorChoice: DataValueHandler!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {
      case .WaterOdorScale(let waterOdorScale):
        switch waterOdorScale {
        case let .NoOdor(index, _): selectedRow = index
        case let .SlightOdor(index, _): selectedRow = index
        case let .Smelly(index, _): selectedRow = index
        case let .VerySmelly(index, _): selectedRow = index
        case let .Devastating(index, _): selectedRow = index
        }
      default: fatalError()
      }

    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleWaterOdorChoice(DataValue.WaterOdorScale(WaterOdorScale.all[selectedRow]))
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

  var abioticFactorChoices: AbioticEcoData!

  var handleWaterTurbidityChoice: DataValueHandler!

  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    var selectedRow: Int = 0
    if let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {
      case .WaterTurbidityScale(let waterTurbidityScale):
        switch waterTurbidityScale {
        case let .CrystalClear(index, _): selectedRow = index
        case let .SlightlyCloudy(index, _): selectedRow = index
        case let .ModeratelyCloudy(index, _): selectedRow = index
        case let .VeryCloudy(index, _): selectedRow = index
        case let .BlackishOrBrownish(index, _): selectedRow = index
        }
      default: fatalError()
      }

    }

    picker.selectRow(selectedRow, inComponent: 0, animated: false)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      let selectedRow = picker.selectedRow(inComponent: 0)
      handleWaterTurbidityChoice(DataValue.WaterTurbidityScale(WaterTurbidityScale.all[selectedRow]))
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

class SoilTextureChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var sandPercentPicker: UIPickerView!

  @IBOutlet weak var siltPercentPicker: UIPickerView!

  @IBOutlet weak var clayPercentPicker: UIPickerView!

  @IBOutlet weak var segmentedControl: UISegmentedControl!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  private var currentPicker: UIPickerView {
    if !sandPercentPicker.isHidden {
      return sandPercentPicker
    } else if !siltPercentPicker.isHidden {
      return siltPercentPicker
    } else if !clayPercentPicker.isHidden {
      return siltPercentPicker
    } else {
      return sandPercentPicker
    }
  }

  private enum Percentage: Int {

    case Zero = 0
    case Ten = 10
    case Twenty = 20
    case Thirty = 30
    case Forty = 40
    case Fifty = 50
    case Sixty = 60
    case Seventy = 70
    case Eighty = 80
    case Ninety = 90
    case OneHundred = 100

    static let all: [Percentage] = [
      .Zero,
      .Ten,
      .Twenty,
      .Thirty,
      .Forty,
      .Fifty,
      .Sixty,
      .Seventy,
      .Eighty,
      .Ninety,
      .OneHundred
    ]

  }

  var abioticFactorChoices: AbioticEcoData!

  var handleSoilTextureChoice: DataValueHandler!

  override func viewDidLoad() {

    super.viewDidLoad()

    let font: [AnyHashable: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]
    segmentedControl.setTitleTextAttributes(font, for: .normal)

    sandPercentPicker.dataSource = self
    siltPercentPicker.dataSource = self
    clayPercentPicker.dataSource = self

    sandPercentPicker.delegate = self
    siltPercentPicker.delegate = self
    clayPercentPicker.delegate = self

  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    var sandSelectedRow: Int = 0
    var siltSelectedRow: Int = 0
    var claySelectedRow: Int = 0
    if let dataValue = abioticFactorChoices.dataValue {

      switch dataValue {
      case .SoilTextureScale(let soilTextureScale):
        sandSelectedRow = Percentage.all.index {
          return soilTextureScale.percentSand == $0.rawValue
        } ?? 0
        siltSelectedRow = Percentage.all.index {
          return soilTextureScale.percentSilt == $0.rawValue
        } ?? 0
        claySelectedRow = Percentage.all.index {
          return soilTextureScale.percentClay == $0.rawValue
        } ?? 0
      default: fatalError()
      }

    }

    segmentedControl.setTitle(
      "\(Percentage.all[sandSelectedRow].rawValue)% Sand",
      forSegmentAt: 0)
    segmentedControl.setTitle(
      "\(Percentage.all[siltSelectedRow].rawValue)% Silt",
      forSegmentAt: 1)
    segmentedControl.setTitle(
      "\(Percentage.all[claySelectedRow].rawValue)% Clay",
      forSegmentAt: 2)

    sandPercentPicker.selectRow(sandSelectedRow, inComponent: 0, animated: false)
    siltPercentPicker.selectRow(siltSelectedRow, inComponent: 0, animated: false)
    clayPercentPicker.selectRow(claySelectedRow, inComponent: 0, animated: false)

    showPercentPicker(sandPercentPicker)

  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {

      let percentSand = Percentage.all[sandPercentPicker.selectedRow(inComponent: 0)].rawValue
      let percentSilt = Percentage.all[siltPercentPicker.selectedRow(inComponent: 0)].rawValue
      let percentClay = Percentage.all[clayPercentPicker.selectedRow(inComponent: 0)].rawValue
      let soilTexture = SoilTextureScale(
        percentSand: percentSand,
        percentSilt: percentSilt,
        percentClay: percentClay)
      handleSoilTextureChoice(DataValue.SoilTextureScale(soilTexture))

    }

    dismiss(animated: true, completion: nil)

  }

  @IBAction func valueChanged(_ sender: UISegmentedControl) {

    switch segmentedControl.selectedSegmentIndex {

    case 0: showPercentPicker(sandPercentPicker)
    case 1: showPercentPicker(siltPercentPicker)
    case 2: showPercentPicker(clayPercentPicker)

    default: fatalError()

    }

  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Percentage.all.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(Percentage.all[row].rawValue)
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    let percentage = Percentage.all[row]
    switch pickerView {

    case sandPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Sand", forSegmentAt: 0)

    case siltPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Silt", forSegmentAt: 1)

    case clayPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Clay", forSegmentAt: 2)

    default: fatalError()

    }

  }

  private func showPercentPicker(_ pickerView: UIPickerView) {

    switch pickerView {

    case sandPercentPicker:
      sandPercentPicker.isHidden = false
      siltPercentPicker.isHidden = true
      clayPercentPicker.isHidden = true

    case siltPercentPicker:
      sandPercentPicker.isHidden = true
      siltPercentPicker.isHidden = false
      clayPercentPicker.isHidden = true

    case clayPercentPicker:
      sandPercentPicker.isHidden = true
      siltPercentPicker.isHidden = true
      clayPercentPicker.isHidden = false

    default: fatalError()

    }

  }

}

class ImageChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var _imageView: UIImageView!

  var presentImageChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentImageChoice()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    _imageView.darkBordered()
  }

}

class ImageChoiceViewController: UIViewController,
  UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var openCameraButton: UIButton!

  @IBOutlet weak var openPhotoLibraryButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var okButton: UIButton!

  var bioticFactorChoices: BioticEcoData? = nil

  var handleImageChoice: ((UIImage) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.darkBordered()
    openCameraButton.rounded()
    openPhotoLibraryButton.rounded()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let image = bioticFactorChoices?.image {
      imageView.image = image
    }
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    switch sender {

    case openCameraButton:
      showImagePickerController(.camera)

    case openPhotoLibraryButton:
      showImagePickerController(.photoLibrary)

    case okButton:
      if let image = imageView.image {
        handleImageChoice(image)
      }
      dismiss(animated: true, completion: nil)

    case cancelButton:
      dismiss(animated: true, completion: nil)

    default: fatalError()

    }


  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String: Any]) {

    var image: UIImage = imageView.image!
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      image = pickedImage
    }
    imageView.image = image.crop(to: image.centeredSquareRect)
    picker.dismiss(animated: true, completion: nil)

  }


  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  private func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {

    if UIImagePickerController.isCameraDeviceAvailable(.rear) {

      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = sourceType
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)

    }

  }

}

class NotesChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var label: UILabel!

  var presentNotesChoice: (() -> Void)!

  @IBAction func touchUpInside() {
    presentNotesChoice()
  }

}

class NotesChoiceViewController: UIViewController, WKNavigationDelegate {

  @IBOutlet weak var textView: UITextView!

  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var cancelButton: UIButton!

  var bioticFactorChoices: BioticEcoData? = nil

  var handleNotesChoice: ((NSAttributedString) -> Void)!

  override func viewDidLoad() {
    super.viewDidLoad()

    textView.lightBordered()
    textView.allowsEditingTextAttributes = true

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let notes = bioticFactorChoices?.notes {
      textView.attributedText = notes
    } else {
      textView.attributedText = nil
    }
  }

  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == okButton {
      handleNotesChoice(textView.attributedText)
    }
    dismiss(animated: true, completion: nil)

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

