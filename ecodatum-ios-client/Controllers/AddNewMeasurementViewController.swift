import Foundation
import SwiftValidator
import UIKit

class AddNewMeasurementViewController: BaseViewController {
  
  @IBOutlet weak var valueLabel: UILabel!
  
  @IBOutlet weak var clearButton: UIButton!
  
  @IBOutlet weak var signButton: UIButton!
  
  @IBOutlet weak var unitButton: UIButton!
  
  @IBOutlet weak var zeroButton: UIButton!
  
  @IBOutlet weak var oneButton: UIButton!
  
  @IBOutlet weak var twoButton: UIButton!
  
  @IBOutlet weak var threeButton: UIButton!
  
  @IBOutlet weak var fourButton: UIButton!
  
  @IBOutlet weak var fiveButton: UIButton!
  
  @IBOutlet weak var sixButton: UIButton!
  
  @IBOutlet weak var sevenButton: UIButton!
  
  @IBOutlet weak var eightButton: UIButton!
  
  @IBOutlet weak var nineButton: UIButton!
  
  @IBOutlet weak var decimalButton: UIButton!
  
  @IBOutlet weak var deleteButton: UIButton!
  
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
      
    valueLabel.roundedAndDarkBordered()
    
    clearButton.roundedAndDarkBordered()
    signButton.roundedAndDarkBordered()
    unitButton.roundedAndDarkBordered()
    decimalButton.roundedAndDarkBordered()
    deleteButton.roundedAndDarkBordered()
    
    zeroButton.roundedAndDarkBordered()
    oneButton.roundedAndDarkBordered()
    twoButton.roundedAndDarkBordered()
    threeButton.roundedAndDarkBordered()
    fourButton.roundedAndDarkBordered()
    fiveButton.roundedAndDarkBordered()
    sixButton.roundedAndDarkBordered()
    sevenButton.roundedAndDarkBordered()
    eightButton.roundedAndDarkBordered()
    nineButton.roundedAndDarkBordered()
    
    saveButton.rounded()
    
  }
    
}




