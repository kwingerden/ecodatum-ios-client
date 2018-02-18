import SwiftValidator
import UIKit

class SiteChoiceViewController: BaseViewController {
  
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
    
    case editButtonItem:
      tableView.setEditing(true, animated: true)
      
    case addButtonItem:
      viewControllerManager.performSegue(to: .createNewSite)
      
    default:
      LOG.error("Unexpected button \(sender)")
    
    }
    
  }
  
  func handleNewSite(_ site: Site) {
    print("new site \(site)")
  }

}

extension SiteChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    if !tableView.isEditing {
      DispatchQueue.main.async {
        let sites = self.viewControllerManager.sites
        self.viewControllerManager.showSite(sites[indexPath.row])
      }
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
    
    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.sites.count
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print("delete")
    }
  }

}





