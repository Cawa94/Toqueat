import MapKit

class HomePoint: NSObject, MKAnnotation {

    static let imageName = "home_location"

    let coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate

        super.init()
    }

}

class CourierPoint: NSObject, MKAnnotation {

    static let imageName = "driver_location"

    let coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate

        super.init()
    }

}
