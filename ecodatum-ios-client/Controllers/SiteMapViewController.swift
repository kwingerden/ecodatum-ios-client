import MapKit
import UIKit

class SiteMapViewController: BaseViewController {

  @IBOutlet weak var mapView: MKMapView!

  private let regionRadius: CLLocationDistance = 1000

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false

    if viewControllerManager.sites.count > 0 {

      let initialSite = viewControllerManager.sites[0]
      let latitude = initialSite.latitude
      let longitude = initialSite.longitude

      let initialLocation = CLLocation(
        latitude: latitude,
        longitude: longitude)
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(
        initialLocation.coordinate,
        regionRadius,
        regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)

      viewControllerManager.sites.forEach {
        let annotation = SiteMapAnnotation(site: $0)
        mapView.addAnnotation(annotation)
      }

    }

  }

  @objc func pressButton(_ sender: UIButton){

    guard let siteButton = sender as? SiteButton else {
      return
    }
    viewControllerManager.showSite(
      siteButton.site,
      segue: .siteNavigationChoice)

  }

}

extension SiteMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    guard let siteMapAnnotation = annotation as? SiteMapAnnotation else {
      return nil
    }

    let identifier = siteMapAnnotation.site.id
    if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {

      view.annotation = annotation
      return view

    } else {

      let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      let siteButton = SiteButton(type: .detailDisclosure)
      siteButton.addTarget(
        self,
        action: #selector(self.pressButton(_:)),
        for: .touchUpInside)
      siteButton.site = siteMapAnnotation.site
      view.rightCalloutAccessoryView = siteButton

      return view

    }

  }

}

fileprivate class SiteMapAnnotation: NSObject, MKAnnotation {

  let site: Site

  let coordinate: CLLocationCoordinate2D

  let title: String?

  let subtitle: String?

  init(site: Site) {
    self.site = site
    self.coordinate = CLLocationCoordinate2D(
      latitude: site.latitude,
      longitude: site.longitude)
    self.title = site.name
    self.subtitle = site.description

    super.init()
  }

}

fileprivate class SiteButton: UIButton {

  var site: Site!

}
