import SwiftValidator
import UIKit

class SurveyChoiceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy private var surveys = viewControllerManager.surveys
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.layer.borderColor = UIColor.lightGray.cgColor
    tableView.layer.borderWidth = 1.0
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
    
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
        self.surveys[indexPath.row])
    }
  }
  
}

extension SurveyChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let survey = surveys[indexPath.row]
    
    cell.textLabel?.text = Formatter.basic.string(for: survey.date)
    
    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return surveys.count
  }
  
}






