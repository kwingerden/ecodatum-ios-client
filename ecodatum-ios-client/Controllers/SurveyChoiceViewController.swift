import SwiftValidator
import UIKit

class SurveyChoiceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var addButtonItem: UIBarButtonItem!
  
  private var surveys: [Survey] = []
  
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
    surveys = viewControllerManager.surveys
    
  }
  
  @IBAction func buttonItemPress(_ sender: UIBarButtonItem) {
    
    switch sender {
      
    case addButtonItem:
      viewControllerManager.performSegue(to: .newSurvey)
      
    default:
      LOG.error("Unexpected button \(sender)")
      
    }
    
  }
  
}

extension SurveyChoiceViewController: SurveyHandler {
  
  func handleNewSurvey(survey: Survey) {
    
    surveys.append(survey)
    tableView.reloadData()
    
  }
  
  func handleSurveyUpdate(survey: Survey) {
    
    if surveys.count == 1 {
      surveys = [survey]
    } else if let indexOf = surveys.index(where: { survey.id == $0.id }) {
      surveys.replaceSubrange(indexOf...indexOf, with: [survey])
    } else {
      LOG.warning("Failed to update surveys collection with site: \(survey)")
    }
    
    tableView.reloadData()
    
  }
  
}

extension SurveyChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showSurvey(
        self.surveys[indexPath.row],
        segue: .surveyNavigationChoice)
    }
  }
  
}

extension SurveyChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let survey = surveys[indexPath.row]
    
    cell.textLabel?.text = Formatter.basic.string(for: survey.date)
    cell.detailTextLabel?.text = survey.description

    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return surveys.count
  }

  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

    let delete = UITableViewRowAction(
      style: .destructive,
      title: "Delete") {

      (action, indexPath) in

      let survey = self.surveys[indexPath.row]
      self.startDeleteSurvey(survey)

    }

    let edit = UITableViewRowAction(
      style: .normal,
      title: "Edit") {

      (action, indexPath) in

      let survey = self.surveys[indexPath.row]
      self.viewControllerManager.showSurvey(
        survey,
        segue: .updateSurvey)

    }

    return [delete, edit]

  }

  private func reloadSurveys(_ deletedSurvey: Survey) {

    postAsyncUIOperation()
    surveys = surveys.filter {
      $0.id != deletedSurvey.id
    }
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






