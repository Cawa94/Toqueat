import UIKit
import RxSwift
import Nuke
import MapKit

class TrackOrderViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    private let regionRadius: CLLocationDistance = 1000
    private var needZoomOut = false
    private var locationsDrawn = false

    var viewModel: TrackOrderViewModel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Barcelona
        let initialLocation = CLLocation(latitude: 41.3868214, longitude: 2.1695953)
        centerMapOnLocation(location: initialLocation)

    }

    // fake result state, called when PulleyController has result
    func onResultState() {
        if let courierCoordiante = viewModel.courierCoordinate {
            let courierPoint = CourierPoint(coordinate: courierCoordiante)
            mapView.addAnnotation(courierPoint)
        }

        drawLocations()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func updateCourierLocation(_ newCoordinate: CLLocationCoordinate2D?) {
        if let courierCoordinate = newCoordinate {
            for existingMarker in self.mapView.annotations {
                if let courierMarker = existingMarker as? CourierPoint {
                    self.mapView.removeAnnotation(courierMarker)
                }
            }
            let courierPoint = CourierPoint(coordinate: courierCoordinate)
            mapView.addAnnotation(courierPoint)
        }
    }

    func drawLocations() {
        if !locationsDrawn, let courierCoordinate = viewModel.courierCoordinate,
            let houseCoordinate = SessionService.isChef
                ? viewModel.pickupCoordinate : viewModel.dropoffCoordinate {
            let dropoff = HomePoint(coordinate: houseCoordinate)
            mapView.addAnnotation(dropoff)

            locationsDrawn = true

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: courierCoordinate))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: houseCoordinate))
            directionRequest.transportType = .walking

            let directions = MKDirections(request: directionRequest)
            directions.calculate { response, error -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }

                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                self.needZoomOut = true
            }
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if needZoomOut {
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect,
                                           edgePadding: UIEdgeInsets(top: 100, left: 100,
                                                                     bottom: 250, right: 100),
                                           animated: true)
            needZoomOut = false
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"

        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }

        if let annotationView = annotationView {
            if annotation as? HomePoint != nil {
                annotationView.image = UIImage(named: HomePoint.imageName)
            } else if annotation as? CourierPoint != nil {
                annotationView.image = UIImage(named: CourierPoint.imageName)
            }

        }

        return annotationView
    }

}
