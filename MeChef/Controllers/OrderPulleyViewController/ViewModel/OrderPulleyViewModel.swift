import Foundation
import RxSwift
import RxCocoa
import SwiftDate

private extension RxTimeInterval {

    static let updateTimeInterval: RxTimeInterval = 10.0

}

final class OrderPulleyViewModel: BaseStatefulViewModel<OrderPulleyViewModel.ResultType> {

    struct ResultType {
        let order: Order
        let driver: OrderDriver
        let stuartJob: StuartJob? // Used to draw origin and destination on map
    }

    var disposeBag = DisposeBag()
    private let orderDriverVariable = Variable<OrderDriver>(.init(latitude: nil,
                                                                  longitude: nil,
                                                                  name: nil,
                                                                  etaToOrigin: nil,
                                                                  etaToDestination: nil))

    init(orderId: Int64, stuartId: Int64?) {
        let orderSingle = NetworkService.shared.getOrderWith(orderId: orderId)
        let trackOrderSingle = NetworkService.shared.getOrderDriverLocation(orderId: orderId)
        let combinedSingle: Single<OrderPulleyViewModel.ResultType>

        Observable<Int>.interval(.updateTimeInterval, scheduler: MainScheduler.instance)
            .flatMap { _ in trackOrderSingle.map { $0 }}
            .asDriver()
            .drive(orderDriverVariable)
            .disposed(by: disposeBag)

        if let stuartId = stuartId {
            let stuartSingle = NetworkService.shared.getStuartJobWith(stuartId)
            combinedSingle = Single.zip(orderSingle, trackOrderSingle, stuartSingle, resultSelector: {
                ResultType(order: $0, driver: $1, stuartJob: $2)
            })

        } else {
            combinedSingle = Single.zip(orderSingle, trackOrderSingle, resultSelector: {
                ResultType(order: $0, driver: $1, stuartJob: nil)
            })
        }

        super.init(dataSource: combinedSingle)
    }

    var orderDriverDriver: Driver<OrderDriver> {
        return orderDriverVariable.asDriver()
    }

    var deliveryInProgress: Bool {
        let dateArrivalString = SessionService.isChef
            ? result.driver.etaToOrigin
            : result.driver.etaToDestination

        if result.order.orderState == .enRoute,
            let deliveryDate = DateInRegion.init(dateArrivalString ?? ""),
            deliveryDate.isInFuture {
            return true
        } else {
            return false
        }
    }

}

extension OrderPulleyViewModel {

    var trackOrderViewModel: TrackOrderViewModel {
        return isLoading
            ? TrackOrderViewModel(driver: nil, stuartJob: nil, isLoading: true)
            : TrackOrderViewModel(driver: result.driver, stuartJob: result.stuartJob, isLoading: false)
    }

    var orderDetailsViewModel: OrderDetailsViewModel {
        return isLoading
            ? OrderDetailsViewModel(order: nil, orderDriver: nil, stuartJob: nil,
                                    isLoading: true, deliveryInProgress: false)
            : OrderDetailsViewModel(order: result.order,
                                    orderDriver: result.driver,
                                    stuartJob: result.stuartJob,
                                    isLoading: false,
                                    deliveryInProgress: deliveryInProgress)
    }

}
