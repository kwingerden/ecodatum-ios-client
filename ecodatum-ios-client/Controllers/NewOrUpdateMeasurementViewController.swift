import Foundation
import SwiftValidator
import UIKit

class NewOrUpdateMeasurementViewController:
BaseViewController,
FormSheetCancelButtonHolder {
  
  @IBOutlet weak var cancelButton: FormSheetCancelButton!
  
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
    
  @IBOutlet weak var calculatorView: UIView!
  
  private var value: String = "0"
  
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
    
    calculatorView.rounded()
    
    saveButton.rounded()
    
    updateUI()
    
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case clearButton:
      value = "0"
      
    case signButton:
      let doubleValue = Double(value)!
      if doubleValue != 0.0 {
        value = "\(-Double(value)!)"
      }
      
    case unitButton:
      break
      // Do nothing
      
    case decimalButton:
      if !value.contains(".") {
        value = value + "."
      }
      
    case deleteButton:
      if value.count > 0 {
        let beforEndIndex = value.index(before: value.endIndex)
        value = String(value[..<beforEndIndex])
        if value.isEmpty {
          value = "0"
        }
      }
      
    case zeroButton:
      if value == "0" {
        return
      } else {
        value = value + "0"
      }
      
    case oneButton:
      if value == "0" {
        value = "1"
      } else {
        value = value + "1"
      }
      
    case twoButton:
      if value == "0" {
        value = "2"
      } else {
        value = value + "2"
      }
    
    case threeButton:
      if value == "0" {
        value = "3"
      } else {
        value = value + "3"
      }
    
    case fourButton:
      if value == "0" {
        value = "4"
      } else {
        value = value + "4"
      }
    
    case fiveButton:
      if value == "0" {
        value = "5"
      } else {
        value = value + "5"
      }
    
    case sixButton:
      if value == "0" {
        value = "6"
      } else {
        value = value + "6"
      }
    
    case sevenButton:
      if value == "0" {
        value = "7"
      } else {
        value = value + "7"
      }
    
    case eightButton:
      if value == "0" {
        value = "8"
      } else {
        value = value + "8"
      }
      
    case nineButton:
      if value == "0" {
        value = "9"
      } else {
        value = value + "9"
      }
      
    case saveButton:
      viewControllerManager.addNewMeasurement(
        value: Double(value)!,
        preAsyncBlock: preAsyncUIOperation,
        postAsyncBlock: postAsyncUIOperation)
      
    default:
      LOG.error("Unexpected button \(sender)")
      
    }
    
    updateUI()
    
  }
  
  private func updateUI() {
    
    guard let measurementUnit = viewControllerManager.measurementUnit else {
      LOG.error("Measurement Unit not set!")
      return
    }
    
    let unit = measurementUnit.measurementUnit.unit
    unitButton.setTitle(unit, for: .normal)
    valueLabel.text = "\(value)"
  
  }
  
}




