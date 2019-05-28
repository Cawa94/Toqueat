import Foundation
import RxSwift
import RxCocoa
import SwiftDate

private extension RxTimeInterval {

    static let updateTimeInterval: RxTimeInterval = 5.0

}

final class OrderPulleyViewModel: BaseStatefulViewModel<OrderPulleyViewModel.ResultType> {

    struct ResultType {
        let order: Order
        let stuartJob: StuartJob?
        let driverPhone: String?
    }

    struct StuartJobNullable {
        let stuartJob: StuartJob?
    }

    private let disposeBag = DisposeBag()
    private let stuartJobVariable = Variable<StuartJobNullable>(.init(stuartJob: nil))

    init(orderId: Int64, stuartId: Int64?) {
        let orderSingle = NetworkService.shared.getOrderWith(orderId: orderId)
        let combinedSingle: Single<OrderPulleyViewModel.ResultType>

        if let stuartId = stuartId {
            let stuartSingle = NetworkService.shared.getStuartJobWith(stuartId)

            combinedSingle = Single.zip(orderSingle, stuartSingle, resultSelector: {
                ResultType(order: $0, stuartJob: $1, driverPhone: nil)
            })

            Observable<Int>.interval(.updateTimeInterval, scheduler: MainScheduler.instance)
                .flatMap { _ in stuartSingle.map { StuartJobNullable.init(stuartJob: $0) }}
                .asDriver()
                .drive(stuartJobVariable)
                .disposed(by: disposeBag)

        } else {
            combinedSingle = orderSingle.map {
                ResultType(order: $0, stuartJob: nil, driverPhone: nil)
            }
        }

        super.init(dataSource: combinedSingle)
    }

    var stuartJobDriver: Driver<StuartJobNullable> {
        return stuartJobVariable.asDriver()
    }

    var deliveryInProgress: Bool {
        let stuartJob = result.stuartJob
        let dateArrivalString = SessionService.isChef
            ? stuartJob?.deliveries.first?.eta.pickup
            : stuartJob?.deliveries.first?.eta.dropoff

        if stuartJob?.status == "in_progress",
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
            ? TrackOrderViewModel(stuartJob: nil, isLoading: true)
            : TrackOrderViewModel(stuartJob: result.stuartJob, isLoading: false)
    }

    var orderDetailsViewModel: OrderDetailsViewModel {
        return isLoading
            ? OrderDetailsViewModel(order: nil, stuartJob: nil, driverPhone: nil,
                                    isLoading: true, deliveryInProgress: false)
            : OrderDetailsViewModel(order: result.order,
                                    stuartJob: result.stuartJob,
                                    driverPhone: result.driverPhone,
                                    isLoading: false,
                                    deliveryInProgress: deliveryInProgress)
    }

}
