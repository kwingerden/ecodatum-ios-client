import SwiftValidator
import UIKit

class PhotoChoiceViewController: BaseViewController {

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

  @IBAction func buttonItemPress(_ sender: UIBarButtonItem) {

    switch sender {

    case addButtonItem:
      viewControllerManager.performSegue(to: .newPhoto)

    default:
      LOG.error("Unexpected button \(sender)")

    }

  }

}

extension PhotoChoiceViewController: PhotoHandler {

  func handleNewPhoto(photo: Photo) {

    viewControllerManager.photo = photo
    viewControllerManager.photos.append(photo)
    tableView.reloadData()

  }

  func handleUpdatedPhoto(photo: Photo) {

    viewControllerManager.handleUpdatedPhoto(photo: photo)
    tableView.reloadData()

  }

  func handleDeletedPhoto(photo: Photo) {

    viewControllerManager.handleDeletedPhoto(photo: photo)
    tableView.reloadData()

  }

}

extension PhotoChoiceViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showSurvey(
        self.viewControllerManager.surveys[indexPath.row],
        segue: .surveyNavigationChoice)
    }
  }

}

extension PhotoChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let survey = self.viewControllerManager.surveys[indexPath.row]

    cell.textLabel?.text = Formatter.basic.string(for: survey.date)
    cell.detailTextLabel?.text = survey.description

    let nextIndicator = UIImageView(image: #imageLiteral(resourceName:"NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator

    return cell

  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return self.viewControllerManager.surveys.count
  }

  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

    let survey = self.viewControllerManager.surveys[indexPath.row]

    let view = UITableViewRowAction(
      style: .normal,
      title: "View") {

      (_, _) in
      self.viewControllerManager.showSurvey(
        survey,
        segue: .viewSurvey)

    }

    let edit = UITableViewRowAction(
      style: .normal,
      title: "Edit") {

      (_, _) in
      let survey = self.viewControllerManager.surveys[indexPath.row]
      self.viewControllerManager.showSurvey(
        survey,
        segue: .updateSurvey)

    }
    edit.backgroundColor = DARK_GREEN

    let delete = UITableViewRowAction(
      style: .destructive,
      title: "Delete") {

      (_, _) in
      self.startDeleteSurvey(survey)

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
         survey.userId == user.userId {

      return [delete, edit, view]

    } else {

      return [view]

    }

  }

  private func reloadSurveys(_ deletedSurvey: Survey) {

    postAsyncUIOperation()
    self.tableView.reloadData()

  }

  private func okToDeleteSurvey(_ survey: Survey) {

    viewControllerManager.deleteSurvey(
      survey: survey,
      preAsyncBlock: preAsyncUIOperation) {
      self.reloadSurveys(survey)
    }

  }

  private func startDeleteSurvey(_ survey: Survey) {

    let okAction = UIAlertAction(
      title: "Ok",
      style: UIAlertActionStyle.destructive) {
      _ in
      self.okToDeleteSurvey(survey)
    }

    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: UIAlertActionStyle.default) {
      _ in
      // do nothing
    }

    guard let dateString = Formatter.basic.string(for: survey.date) else {
      LOG.error("Failed to parse survey date: \(survey.date)")
      return
    }

    let alertController = UIAlertController(
      title: "Delete Survey?",
      message: "Are you sure you want to delete survey taken at \(dateString)?",
      preferredStyle: .alert)

    alertController.addAction(okAction)
    alertController.addAction(cancelAction)

    present(
      alertController,
      animated: true,
      completion: nil)

  }

}






