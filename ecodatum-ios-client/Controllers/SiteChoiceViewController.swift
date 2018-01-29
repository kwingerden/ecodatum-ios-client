import SwiftValidator
import UIKit

class SiteChoiceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy private var sites = viewControllerManager.sites
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.layer.borderColor = UIColor.black.cgColor
    tableView.layer.borderWidth = 0.25
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
  
  }
  
}

extension SiteChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    viewControllerManager.showSite(sites[indexPath.row])
  }
  
}

extension SiteChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let site = sites[indexPath.row]
    
    cell.textLabel?.text = site.name
    cell.detailTextLabel?.text = site.description
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sites.count
  }
  
}





