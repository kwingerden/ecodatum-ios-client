import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateDataViewController: BaseFormSheetDisplayable {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var saveButton: UIButton!
  
  private var factorChoice: String? = nil
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    
    saveButton.rounded()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
 
  }
  
  @IBAction override func touchUpInside(_ sender: UIButton) {
    
  }
  
  override func postAsyncUIOperation() {
    
    super.postAsyncUIOperation()
    
    if viewControllerManager.isFormSheetSegue {
      dismiss(animated: true, completion: nil)
    }
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let identifier = segue.identifier {
    
      switch identifier {
        
      case "factorChoice":
        if let destination = segue.destination as? FactorChoicePopoverViewController {
          destination.handleFactorChoice = handleFactorChoice
        }
        
      default:
        break
        
      }
      
    }
    
  }
  
  func presentFactorChoice() {
    performSegue(withIdentifier: "factorChoice", sender: nil)
  }
  
  func handleFactorChoice(_ factorChoice: String) {
    self.factorChoice = factorChoice
    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
  }
  
}

extension NewOrUpdateDataViewController: UITableViewDelegate {

}

extension NewOrUpdateDataViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "factorChoice",
        for: indexPath) as! FactorChoiceTableViewCell
      
      var image = UIImage(named: "HelpGlyph")
      if let factorChoice = factorChoice {
  
        switch factorChoice {
          
        case "Air":
          image = UIImage(named: "AirLogo")
        case "Soil":
          image = UIImage(named: "SoilLogo")
        case "Water":
          image = UIImage(named: "WaterLogo")
        case "Biotic":
          image = UIImage(named: "BioticLogo")
        default:
          break
          
        }
        
        cell.chooseFactorLabel.text = factorChoice
        
      }
  
      cell.chooseFactorButton.setImage(image, for: .normal)
      cell.presentFactorChoice = presentFactorChoice
      
      return cell
    
    } else {
      
      return UITableViewCell()
    
    }
    
  }
  
}

class FactorChoiceTableViewCell: UITableViewCell {

  @IBOutlet weak var chooseFactorLabel: UILabel!
  
  @IBOutlet weak var chooseFactorButton: UIButton!

  var presentFactorChoice: (() -> Void)!

  @IBAction func touchUpInside(_ sender: UIButton) {
    presentFactorChoice()
  }
  
}

class FactorChoicePopoverViewController: UIViewController {
  
  @IBOutlet weak var airButton: UIButton!
  
  @IBOutlet weak var soilButton: UIButton!
  
  @IBOutlet weak var waterButton: UIButton!
  
  @IBOutlet weak var bioticButton: UIButton!
  
  var handleFactorChoice: ((String) -> Void)!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case airButton:
      handleFactorChoice("Air")
    case soilButton:
      handleFactorChoice("Soil")
    case waterButton:
      handleFactorChoice("Water")
    case bioticButton:
      handleFactorChoice("Biotic")
    default:
      break
      
    }
    
    dismiss(animated: true, completion: nil)
  
  }
  
}


