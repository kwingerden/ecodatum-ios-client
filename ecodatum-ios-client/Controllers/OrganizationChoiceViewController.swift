import Foundation
import UIKit

class OrganizationChoiceViewController: BaseViewController  {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  
    tableView.delegate = self
    tableView.dataSource = self
  
    tableView.layer.borderColor = UIColor.lightGray.cgColor
    tableView.layer.borderWidth = 1.0
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
        
  }
  
}

extension OrganizationChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showOrganization(
        self.viewControllerManager.organizations[indexPath.row])
    }
  }
  
}

extension OrganizationChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let organization = viewControllerManager.organizations[indexPath.row]
    
    cell.textLabel?.text = organization.name
    cell.detailTextLabel?.text = organization.description
    
    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
  
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.organizations.count
  }
  
}



