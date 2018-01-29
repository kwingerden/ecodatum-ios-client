import Foundation
import UIKit

class OrganizationChoiceViewController: BaseViewController  {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy private var organizations = viewControllerManager.organizations
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  
    tableView.delegate = self
    tableView.dataSource = self
  
    tableView.layer.borderColor = UIColor.black.cgColor
    tableView.layer.borderWidth = 0.25
    
  }
  
}

extension OrganizationChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    viewControllerManager.showOrganization(organizations[indexPath.row])
  }
  
}

extension OrganizationChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let organization = organizations[indexPath.row]
    
    cell.textLabel?.text = organization.name
    cell.detailTextLabel?.text = organization.description
    
    return cell
  
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return organizations.count
  }
  
}



