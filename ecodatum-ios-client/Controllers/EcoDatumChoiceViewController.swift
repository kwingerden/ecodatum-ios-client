import SwiftValidator
import UIKit

class EcoDatumChoiceViewController: BaseContentViewScrollable {

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var addButtonItem: UIBarButtonItem!

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

    tableView.layer.borderColor = UIColor.lightGray.cgColor
    tableView.layer.borderWidth = 1.0

    tableView.tableFooterView = UIView(frame: CGRect.zero)

  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false

  }

  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {

    super.prepare(for: segue, sender: sender)

    guard let identifier = segue.identifier,
          let viewControllerSegue = ViewControllerSegue(rawValue: identifier) else {
      LOG.error("Failed to determine view controller segue")
      return
    }

    if let formSheetSegue = segue as? FormSheetSegue {

      switch viewControllerSegue {

      case .newEcoDatum:
        formSheetSegue.segueType = .new

      case .updateEcoDatum:
        formSheetSegue.segueType = .edit

      case .viewEcoDatum:
        formSheetSegue.segueType = .view

      default:
        LOG.error("Unexpected segue type: \(identifier)")

      }

    } else if viewControllerSegue == .siteNavigationChoice {

      if let viewController = segue.destination as? BaseNavigationChoice {
        viewController.isNavigationBarHidden = false
      }

    }

  }

  @IBAction func buttonItemPress(_ sender: UIBarButtonItem) {

    switch sender {

    case addButtonItem:
      viewControllerManager.performSegue(to: .newEcoDatum)

    default:
      LOG.error("Unexpected button \(sender)")

    }

  }

}

extension EcoDatumChoiceViewController: EcoDatumHandler {

  func handleNewEcoDatum(ecoDatum: EcoDatum) {

    viewControllerManager.ecoDatum = ecoDatum
    viewControllerManager.ecoData.append(ecoDatum)
    tableView.reloadData()

  }

  func handleUpdatedEcoDatum(ecoDatum: EcoDatum) {

    viewControllerManager.handleUpdatedEcoDatum(ecoDatum: ecoDatum)
    tableView.reloadData()

  }

  func handleDeletedEcoDatum(ecoDatum: EcoDatum) {

    viewControllerManager.handleDeletedEcoDatum(ecoDatum: ecoDatum)
    tableView.reloadData()

  }

}

extension EcoDatumChoiceViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let ecoDatum = viewControllerManager.ecoData[indexPath.row]
    switch ecoDatum.ecoFactor {
    case .Abiotic?: return 228
    case .Biotic?: return 228
    default: fatalError()
    }
  }

}

extension EcoDatumChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let ecoDatum = viewControllerManager.ecoData[indexPath.row]
    switch ecoDatum.ecoFactor {

    case .Abiotic?:
      let cell = tableView.dequeueReusableCell(withIdentifier: "abioticCell") as! AbioticChoiceTableViewCell
      cell.dateLabel.text = DATE_FORMATTER.string(from: ecoDatum.date)
      cell.timeLabel.text = TIME_FORMATTER.string(from: ecoDatum.time)
      cell.ecoSystemFactorLabel.text = ecoDatum.ecoFactor!.rawValue
      cell.abioticFactorLabel.text = ecoDatum.abioticEcoData!.abioticFactor!.rawValue
      switch ecoDatum.abioticEcoData!.dataType! {

      case .Air(let airDataType):
        cell.dataTypeLabel.text = airDataType.rawValue

      case .Soil(let soilDataType):
        cell.dataTypeLabel.text = soilDataType.rawValue

      case .Water(let waterDataType):
        cell.dataTypeLabel.text = waterDataType.rawValue

      }

      let dataUnitLabel: MTMathUILabel = MTMathUILabel()
      cell.dataUnitView.insertSubview(dataUnitLabel, at: 0)

      dataUnitLabel.latex = ecoDatum.abioticEcoData!.dataUnit!.rawValue
      dataUnitLabel.textAlignment = .left
      dataUnitLabel.fontSize = 14
      dataUnitLabel.textColor = .black
      dataUnitLabel.frame.size = cell.dataUnitView.frame.size

      switch ecoDatum.abioticEcoData!.dataValue! {

      case .DecimalDataValue(let decimalDataValue):
        cell.dataValueLabel.text = decimalDataValue.description

      case .AirOzoneScale(let airOzoneScale):
        var text = ""
        switch airOzoneScale {
        case .LessThan90(_, let label): text = label
        case .Between90And150(_, let label): text = label
        case .GreaterThan150To210(_, let label): text = label
        case .GreaterThan210(_, let label): text = label
        }
        cell.dataValueLabel.text = text

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

      return cell

    case .Biotic?:
      let cell = tableView.dequeueReusableCell(withIdentifier: "bioticCell") as! BioticChoiceTableViewCell
      cell.dateLabel.text = DATE_FORMATTER.string(from: ecoDatum.date)
      cell.timeLabel.text = TIME_FORMATTER.string(from: ecoDatum.time)
      cell.ecoSystemFactorLabel.text = ecoDatum.ecoFactor!.rawValue
      cell._imageView.image = ecoDatum.bioticEcoData!.image
      cell.textView.attributedText = ecoDatum.bioticEcoData!.notes

      cell._imageView.darkBordered()


      return cell

    default: fatalError()

    }

  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.ecoData.count
  }

  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

    let ecoData = viewControllerManager.ecoData[indexPath.row]

    let view = UITableViewRowAction(
      style: .normal,
      title: "View") {

      (_, _) in
      self.viewControllerManager.showEcoDatum(
        ecoData,
        segue: .viewEcoDatum)

    }

    let edit = UITableViewRowAction(
      style: .normal,
      title: "Edit") {

      (_, _) in
      self.viewControllerManager.showEcoDatum(
        ecoData,
        segue: .updateEcoDatum)

    }
    edit.backgroundColor = DARK_GREEN

    let delete = UITableViewRowAction(
      style: .destructive,
      title: "Delete") {

      (_, _) in
      self.startDeleteEcoDatum(ecoData)

    }

    guard let user = viewControllerManager.authenticatedUser else {
      return []
    }

    if user.isRootUser {
      return [delete, edit, view]
    }

    guard let organizationMember = viewControllerManager.organizationMembers.first(
      where: { $0.user.id == user.userId }),
          let organizationMemberRole = OrganizationMemberRole(
            rawValue: organizationMember.role.name) else {

      return []

    }

    if organizationMemberRole == .ADMINISTRATOR ||
         ecoData.userId == user.userId {

      return [delete, edit, view]

    } else {

      return [view]

    }

  }

  private func reloadEcoData(_ ecoDatum: EcoDatum) {

    postAsyncUIOperation()
    tableView.reloadData()

  }

  private func okToDeleteEcoDatum(_ ecoDatum: EcoDatum) {

    viewControllerManager.deleteEcoDatum(
      ecoDatum: ecoDatum,
      preAsyncBlock: preAsyncUIOperation) {
      self.reloadEcoData(ecoDatum)
    }

  }

  private func startDeleteEcoDatum(_ ecoDatum: EcoDatum) {

    let okAction = UIAlertAction(
      title: "Ok",
      style: UIAlertActionStyle.destructive) {
      _ in
      self.okToDeleteEcoDatum(ecoDatum)
    }

    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: UIAlertActionStyle.default) {
      _ in
      // do nothing
    }

    let alertController = UIAlertController(
      title: "Delete Data?",
      message: "Are you sure you want to delete this data?",
      preferredStyle: .alert)

    alertController.addAction(okAction)
    alertController.addAction(cancelAction)

    present(
      alertController,
      animated: true,
      completion: nil)

  }

}

class AbioticChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var ecoSystemFactorLabel: UILabel!
  @IBOutlet weak var abioticFactorLabel: UILabel!
  @IBOutlet weak var dataTypeLabel: UILabel!
  @IBOutlet weak var dataUnitView: UIView!
  @IBOutlet weak var dataValueLabel: UILabel!
  
}

class BioticChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var ecoSystemFactorLabel: UILabel!
  @IBOutlet weak var _imageView: UIImageView!
  @IBOutlet weak var textView: UITextView!

  override func layoutSubviews() {
    super.layoutSubviews()
    _imageView.darkBordered()
    textView.lightBordered()
    textView.allowsEditingTextAttributes = false
  }

}




