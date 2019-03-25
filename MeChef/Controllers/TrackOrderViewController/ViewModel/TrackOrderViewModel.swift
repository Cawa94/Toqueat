import Foundation
import RxSwift
import RxCocoa
import MapKit

private extension RxTimeInterval {

    static let updateTimeInterval: RxTimeInterval = 5.0

}

final class TrackOrderViewModel: BaseStatefulViewModel<TrackOrderViewModel.OrderWithStuart> {

    struct OrderWithStuart {
        let order: Order
        let stuartJob: StuartJob?
    }

    private let disposeBag = DisposeBag()
    private let stuartJobVariable = Variable<StuartJob?>(nil)

    init(orderId: Int64, stuartId: Int64?) {
        let orderSingle = NetworkService.shared.getOrderWith(orderId: orderId)
        var trackRequest: Single<OrderWithStuart>
        if let stuartId = stuartId {
            let stuartSingle = NetworkService.shared.getStuartJobWith(stuartId)

            Observable<Int>.interval(.updateTimeInterval, scheduler: MainScheduler.instance)
                .flatMap { _ in stuartSingle }
                .asDriver()
                .drive(stuartJobVariable)
                .disposed(by: disposeBag)

            trackRequest = Single.zip(orderSingle, stuartSingle, resultSelector: { order, job in
                OrderWithStuart(order: order, stuartJob: job)
            })
            super.init(dataSource: trackRequest)
        } else {
            trackRequest = orderSingle.map { order -> TrackOrderViewModel.OrderWithStuart in
                OrderWithStuart(order: order, stuartJob: nil)
            }
            super.init(dataSource: trackRequest)
        }
    }

    var stuartJobDriver: Driver<StuartJob> {
        return stuartJobVariable.asDriver().filterNil()
    }

}

extension TrackOrderViewModel {

    var courierCoordinate: CLLocationCoordinate2D? {
        guard let latitude = result.stuartJob?.driver?.latitude,
            let longitude = result.stuartJob?.driver?.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

    var pickupCoordinate: CLLocationCoordinate2D? {
        guard let latitude = result.stuartJob?.deliveries.first?.pickup.latitude,
            let longitude = result.stuartJob?.deliveries.first?.pickup.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

    var dropoffCoordinate: CLLocationCoordinate2D? {
        guard let latitude = result.stuartJob?.deliveries.first?.dropoff.latitude,
            let longitude = result.stuartJob?.deliveries.first?.dropoff.longitude
            else { return nil }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                      longitude: CLLocationDegrees(truncating: longitude))
    }

}
