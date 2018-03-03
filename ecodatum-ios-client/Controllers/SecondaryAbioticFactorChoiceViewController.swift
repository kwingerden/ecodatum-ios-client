import SwiftValidator
import UIKit

class SecondaryAbioticFactorChoiceViewController: BaseViewController {

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

    viewControllerManager.secondaryAbioticFactor = nil
    viewControllerManager.measurementUnit = nil

  }
  
}

extension SecondaryAbioticFactorChoiceViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.viewControllerManager.showMeasurementUnits(
        self.viewControllerManager.secondaryAbioticFactors[indexPath.row])
    }
  }

}

extension SecondaryAbioticFactorChoiceViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let secondaryAbioticFactor = viewControllerManager.secondaryAbioticFactors[indexPath.row]

    cell.textLabel?.text = secondaryAbioticFactor.label
    cell.detailTextLabel?.text = secondaryAbioticFactor.description

    let nextIndicator = UIImageView(image: #imageLiteral(resourceName: "NextGlyph"))
    nextIndicator.tintColor = UIColor.black
    cell.accessoryView = nextIndicator

    return cell

  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllerManager.secondaryAbioticFactors.count
  }

}
