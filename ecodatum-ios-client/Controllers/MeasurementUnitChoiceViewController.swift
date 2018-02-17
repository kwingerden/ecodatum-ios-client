import Foundation
import UIKit

class MeasurementUnitChoiceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy private var measurementUnits = viewControllerManager.measurementUnits
  
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

extension MeasurementUnitChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showMeasurementUnit(
        self.measurementUnits[indexPath.row])
    }
  }
  
}

extension MeasurementUnitChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let measurementUnit = measurementUnits[indexPath.row]
    
    cell.textLabel?.text = measurementUnit.name
    cell.detailTextLabel?.text = "measurement unit description"
    
    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return measurementUnits.count
  }
  
}




