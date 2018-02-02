import SwiftValidator
import UIKit

class AbioticFactorChoiceViewController: BaseViewController {
  
  @IBOutlet weak var airButton: UIButton!
  
  @IBOutlet weak var soilButton: UIButton!
  
  @IBOutlet weak var waterButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()

    airButton.rounded()
    soilButton.rounded()
    waterButton.rounded()
    
  }
  
  @IBAction func touchUpInsider(_ sender: UIButton) {
    
    switch sender {
      
    case airButton:
      let air = viewControllerManager.abioticFactors.filter {
        $0.name.lowercased() == "air"
      }.first!
      viewControllerManager.showAbioticFactor(
        air,
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    case soilButton:
      let soil = viewControllerManager.abioticFactors.filter {
        $0.name.lowercased() == "soil"
        }.first!
      viewControllerManager.showAbioticFactor(
        soil,
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    case waterButton:
      let water = viewControllerManager.abioticFactors.filter {
        $0.name.lowercased() == "water"
        }.first!
      viewControllerManager.showAbioticFactor(
        water,
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unrecognized button: \(sender)")
      
    }
    
  }
  
}



