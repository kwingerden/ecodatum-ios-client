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

  case image

  static let all: [AbioticFactor] = [
    .image
  ]

}

fileprivate enum BioticFactor: String {

  case Air
  case Soil
  case Water

  static let all: [BioticFactor] = [
    .Air,
    .Soil,
    .Water
  ]

}

fileprivate enum Data: Int {

  case date
  case time
  case ecoFactor
  case description

  static let all: [Data] = [
    .date,
    .time,
    .ecoFactor
  ]

}

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var saveButton: UIButton!

  private var dateChoice: Date = Date()
  
  private var timeChoice: Date = Date()

  private var ecoFactorChoice: EcoFactor? = nil

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
    tableView.reloadRows(
      at: [
        IndexPath(
          row: 0,
          section: Data.date.rawValue)
      ],
      with: .automatic)

  }

  func presentTimeChoice() {
    performSegue(withIdentifier: "timeChoice", sender: nil)
  }
  
  func handleTimeChoice(_ date: Date) {
    
    self.timeChoice = date
    tableView.reloadRows(
      at: [
        IndexPath(
          row: 0,
          section: Data.time.rawValue)
      ],
      with: .automatic)
    
  }
  
  func presentEcoFactorChoice() {
    performSegue(withIdentifier: "ecoFactorChoice", sender: nil)
  }

  fileprivate func handleEcoFactorChoice(_ ecoFactor: EcoFactor) {

    self.ecoFactorChoice = ecoFactor
    tableView.reloadRows(
      at: [
        IndexPath(
          row: 0,
          section: Data.ecoFactor.rawValue)
      ],
      with: .automatic)

  }

}

extension NewOrUpdateDataViewController: UITableViewDelegate {

}

extension NewOrUpdateDataViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

    switch Data(rawValue: section) {
    case .date?: return "Date"
    case .time?: return "Time"
    case .ecoFactor?: return "Ecosystem Factor"
    default: return nil
    }

  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return Data.all.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.section {

    case 0: return makeDateChoiceCell(tableView, indexPath)
    case 1: return makeTimeChoiceCell(tableView, indexPath)
    case 2: return makeEcoFactorChoiceCell(tableView, indexPath)
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



