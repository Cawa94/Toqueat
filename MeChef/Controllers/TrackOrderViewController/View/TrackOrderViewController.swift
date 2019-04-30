import UIKit
import RxSwift
import Nuke
import MapKit

class TrackOrderViewController: BaseStatefulController<TrackOrderViewModel.OrderWithStuart>,
    MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    private let regionRadius: CLLocationDistance = 1000
    private var needZoomOut = false
    private var locationsDrawn = false

    var trackOrderViewModel: TrackOrderViewModel! {
        didSet {
            viewModel = trackOrderViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 41.3868214, longitude: 2.1695953)
        centerMapOnLocation(location: initialLocation)
    }

    override func configureNavigationBar() {
        title = "Track Order"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeOrder))
    }

    @objc func closeOrder() {
        NavigationService.popNavigationTopController()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        if let courierCoordiante = trackOrderViewModel.courierCoordinate {
            let courier = MapPoint(title: "Bob",
                                   locationName: "courier",
                                   coordinate: courierCoordiante)
            mapView.addAnnotation(courier)
        }

        drawLocations()

        trackOrderViewModel.stuartJobDriver.drive(onNext: { stuartJob in
            guard let latitude = stuartJob.driver?.latitude,
                let longitude = stuartJob.driver?.longitude
                else { return }
            let courierCoordiante = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                                           longitude: CLLocationDegrees(truncating: longitude))
            self.updateCourierLocation(courierCoordiante)
        })
        .disposed(by: disposeBag)
    }

    func updateCourierLocation(_ newCoordinate: CLLocationCoordinate2D?) {
        if let courierCoordinate = newCoordinate {
            for existingMarker in self.mapView.annotations {
                if let courierMarker = existingMarker as? CourierPoint {
                    self.mapView.removeAnnotation(courierMarker)
                }
            }
            let courierPoint = CourierPoint(title: "Courier",
                                            locationName: "on my way",
                                            coordinate: courierCoordinate)
            mapView.addAnnotation(courierPoint)
        }
    }

    func drawLocations() {
        if !locationsDrawn, let pickupCoordinate = trackOrderViewModel.pickupCoordinate,
            let dropoffCoordinate = trackOrderViewModel.dropoffCoordinate {
            let pickup = MapPoint(title: "Chef house",
                                  locationName: "pickup",
                                  coordinate: pickupCoordinate)
            mapView.addAnnotation(pickup)

            let dropoff = MapPoint(title: "Your house",
                                   locationName: "dropoff",
                                   coordinate: dropoffCoordinate)
            mapView.addAnnotation(dropoff)

            locationsDrawn = true

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: dropoffCoordinate))
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
                                                                     bottom: 100, right: 100),
                                           animated: true)
            needZoomOut = false
        }
    }

}
