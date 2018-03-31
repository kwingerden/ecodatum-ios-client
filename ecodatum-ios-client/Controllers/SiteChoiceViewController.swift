import SwiftValidator
import UIKit

class SiteChoiceViewController: BaseContentViewScrollable {

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

      case .newSite:
        formSheetSegue.segueType = .new

      case .updateSite:
        formSheetSegue.segueType = .edit

      case .viewSite:
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
      viewControllerManager.performSegue(to: .newSite)

    default:
      LOG.error("Unexpected button \(sender)")

    }

  }

}

extension SiteChoiceViewController: SiteHandler {

  func handleNewSite(site: Site) {

    viewControllerManager.site = site
    viewControllerManager.sites.append(site)
    tableView.reloadData()

  }

  func handleUpdatedSite(site: Site) {

    viewControllerManager.handleUpdatedSite(site: site)
    tableView.reloadData()

  }

  func handleDeletedSite(site: Site) {

    viewControllerManager.handleDeletedSite(site: site)
    tableView.reloadData()

  }

}

extension SiteChoiceViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {

    DispatchQueue.main.async {
      self.viewControllerManager.showSite(
        self.viewControllerManager.sites[indexPath.row],
        segue: .siteNavigationChoice)
    }

  }

}

extension SiteChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let site = viewControllerManager.sites[indexPath.row]

    cell.textLabel?.text = site.name
    cell.detailTextLabel?.text = site.description

    let nextIndicator = UIImageView(image: #imageLiteral(resourceName:"NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator

    return cell

  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.sites.count
  }

  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

    let site = viewControllerManager.sites[indexPath.row]

    let view = UITableViewRowAction(
      style: .normal,
      title: "View") {

      (_, _) in
      self.viewControllerManager.showSite(
        site,
        segue: .viewSite)

    }

    let edit = UITableViewRowAction(
      style: .normal,
      title: "Edit") {

      (_, _) in
      self.viewControllerManager.showSite(
        site,
        segue: .updateSite)

    }
    edit.backgroundColor = DARK_GREEN

    let delete = UITableViewRowAction(
      style: .destructive,
      title: "Delete") {

      (_, _) in
      self.startDeleteSite(site)

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
         site.userId == user.userId {

      return [delete, edit, view]

    } else {

      return [view]

    }

  }

  private func reloadSites(_ deletedSite: Site) {

    postAsyncUIOperation()
    tableView.reloadData()

  }

  private func okToDeleteSite(_ site: Site) {

    viewControllerManager.deleteSite(
      site: site,
      preAsyncBlock: preAsyncUIOperation) {
      self.reloadSites(site)
    }

  }

  private func startDeleteSite(_ site: Site) {

    let okAction = UIAlertAction(
      title: "Ok",
      style: UIAlertActionStyle.destructive) {
      _ in
      self.okToDeleteSite(site)
    }

    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: UIAlertActionStyle.default) {
      _ in
      // do nothing
    }

    let alertController = UIAlertController(
      title: "Delete Site?",
      message: "Are you sure you want to delete site \(site.name)?",
      preferredStyle: .alert)

    alertController.addAction(okAction)
    alertController.addAction(cancelAction)

    present(
      alertController,
      animated: true,
      completion: nil)

  }

}





