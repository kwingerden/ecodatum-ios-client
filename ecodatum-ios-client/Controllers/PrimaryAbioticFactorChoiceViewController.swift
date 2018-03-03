import SwiftValidator
import UIKit

class PrimaryAbioticFactorChoiceViewController: BaseViewController {
  
  @IBOutlet weak var airButton: UIButton!
  
  @IBOutlet weak var soilButton: UIButton!
  
  @IBOutlet weak var waterButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()

    airButton.rounded()
    soilButton.rounded()
    waterButton.rounded()
    
  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false

    viewControllerManager.primaryAbioticFactor = nil
    viewControllerManager.secondaryAbioticFactor = nil
    viewControllerManager.measurementUnit = nil

  }

  @IBAction func touchUpInsider(_ sender: UIButton) {

    guard let title = sender.title(for: .normal),
          let primaryAbioticFactor = viewControllerManager.findPrimaryAbioticFactor(title) else {
      LOG.error("Failed to determine primary abiotic factor.")
      return
    }

    viewControllerManager.showSecondaryAbioticFactors(primaryAbioticFactor)
    
  }

}



