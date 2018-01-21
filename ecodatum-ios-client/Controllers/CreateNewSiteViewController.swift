import Foundation
import UIKit

class CreateNewSiteViewController: BaseViewController {
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var createNewSiteButton: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    descriptionTextView.layer.borderWidth = 0.5
    descriptionTextView.layer.cornerRadius = 8
  
    createNewSiteButton.roundedButton()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
  
    vcm?.performSegue(from: self, to: .siteMap)
    
  }
  
}


