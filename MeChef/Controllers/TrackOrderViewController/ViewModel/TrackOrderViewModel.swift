import Foundation
import MapKit

struct TrackOrderViewModel {

    let driver: OrderDriver?
    let stuartJob: StuartJob?
    let isLoading: Bool

}

extension TrackOrderViewModel {

    var courierCoordinate: CLLocationCoordinate2D? {
        guard let latitude = driver?.latitude,
            let longitude = driver?.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

    var pickupCoordinate: CLLocationCoordinate2D? {
        guard let latitude = stuartJob?.deliveries.first?.pickup.latitude,
            let longitude = stuartJob?.deliveries.first?.pickup.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

    var dropoffCoordinate: CLLocationCoordinate2D? {
        guard let latitude = stuartJob?.deliveries.first?.dropoff.latitude,
            let longitude = stuartJob?.deliveries.first?.dropoff.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

}
