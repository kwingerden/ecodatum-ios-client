import Alamofire
import AlamofireImage
import SwiftValidator
import UIKit

class PhotoChoiceViewController: BaseContentViewScrollable {

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
        
      case .newPhoto:
        formSheetSegue.segueType = .new
        
      case .updatePhoto:
        formSheetSegue.segueType = .edit
        
      case .viewPhoto:
        formSheetSegue.segueType = .view
        
      default:
        LOG.error("Unexpected segue type: \(identifier)")
        
      }
      
    }
    
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

}

extension PhotoChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoChoiceTableViewCell
    let photo = viewControllerManager.photos[indexPath.row]
    viewControllerManager.setImage(
      cell._imageView,
      imageId: photo.id)
    cell.descriptionView?.text = photo.description
    
    return cell

  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.photos.count
  }

  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

    let photo = viewControllerManager.photos[indexPath.row]

    let view = UITableViewRowAction(
      style: .normal,
      title: "View") {

      (_, _) in
      self.viewControllerManager.showPhoto(
        photo,
        segue: .viewPhoto)

    }

    let edit = UITableViewRowAction(
      style: .normal,
      title: "Edit") {

      (_, _) in
      self.viewControllerManager.showPhoto(
        photo,
        segue: .updatePhoto)

    }
    edit.backgroundColor = DARK_GREEN

    let delete = UITableViewRowAction(
      style: .destructive,
      title: "Delete") {

      (_, _) in
      self.startDeletePhoto(photo)

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
         photo.userId == user.userId {

      return [delete, edit, view]

    } else {

      return [view]

    }

  }

  private func reloadPhotos(_ deletedPhoto: Photo) {

    postAsyncUIOperation()
    self.tableView.reloadData()

  }

  private func okToDeletePhoto(_ photo: Photo) {

    viewControllerManager.deletePhoto(
      photo: photo,
      preAsyncBlock: preAsyncUIOperation) {
      self.reloadPhotos(photo)
    }

  }

  private func startDeletePhoto(_ photo: Photo) {

    let okAction = UIAlertAction(
      title: "Ok",
      style: UIAlertActionStyle.destructive) {
      _ in
      self.okToDeletePhoto(photo)
    }

    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: UIAlertActionStyle.default) {
      _ in
      // do nothing
    }

    let alertController = UIAlertController(
      title: "Delete Photo?",
      message: "Are you sure you want to delete this photo?",
      preferredStyle: .alert)

    alertController.addAction(okAction)
    alertController.addAction(cancelAction)

    present(
      alertController,
      animated: true,
      completion: nil)

  }

}

class PhotoChoiceTableViewCell: UITableViewCell {
  
  @IBOutlet weak var _imageView: UIImageView!
  
  @IBOutlet weak var descriptionView: UITextView!
  
  override func layoutSubviews() {
    _imageView.darkBordered()
    descriptionView.rounded()
    descriptionView.lightBordered()
  }
  
}





