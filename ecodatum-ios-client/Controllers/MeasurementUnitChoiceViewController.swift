import Foundation
import UIKit

class MeasurementUnitChoiceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!

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
    viewControllerManager.measurementUnit = nil

  }
  
}

extension MeasurementUnitChoiceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 125
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showMeasurement(
        self.viewControllerManager.measurementUnits[indexPath.row])
    }
  }
  
}

extension MeasurementUnitChoiceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let measurementUnit = viewControllerManager.measurementUnits[indexPath.row]
    
    cell.textLabel?.text = measurementUnit.measurementUnit.unit
    let label = measurementUnit.measurementUnit.label
    let description = measurementUnit.measurementUnit.description.replaceNewlines()
    cell.detailTextLabel?.text = "\(label): \(description)"
    
    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.measurementUnits.count
  }
  
}




