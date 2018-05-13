import MapKit
import UIKit

class SiteMapViewController: BaseViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllerManager.sites
  }

}
