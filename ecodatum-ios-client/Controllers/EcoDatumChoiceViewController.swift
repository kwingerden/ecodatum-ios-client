import SwiftValidator
import UIKit

class EcoDatumChoiceViewController: BaseContentViewScrollable {

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var addButtonItem: UIBarButtonItem!

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
    return 100
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {

    DispatchQueue.main.async {
      self.viewControllerManager.showEcoDatum(
        self.viewControllerManager.ecoData[indexPath.row],
        segue: .siteNavigationChoice)
    }

  }

}

extension EcoDatumChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let ecoDatum = viewControllerManager.ecoData[indexPath.row]

    cell.textLabel?.text = ecoDatum.id!
    cell.detailTextLabel?.text = ecoDatum.id!

    let nextIndicator = UIImageView(image: #imageLiteral(resourceName:"NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator

    return cell

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





