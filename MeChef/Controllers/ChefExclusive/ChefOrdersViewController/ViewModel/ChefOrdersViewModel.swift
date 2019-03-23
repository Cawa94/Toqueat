import Foundation
import RxSwift

final class ChefOrdersViewModel: BaseTableViewModel<[Order], Order> {

    private let disposeBag = DisposeBag()

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getOrdersFor(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension ChefOrdersViewModel {

    func createStuartJobWith(orderId: Int64, chefLocation: StuartLocation) -> Single<Order> {
        return NetworkService.shared.getOrderWith(orderId: orderId)
            .flatMap { order -> Single<Order> in
                guard order.stuartId == nil
                    else { return Single.just(order) }
                let dropOff = StuartLocation(address: order.deliveryAddress,
                                             comment: order.deliveryComment,
                                             contact: order.user.stuartContact,
                                             packageType: "small",
                                             packageDescription: "",
                                             clientReference: nil)
                let jobParameters = StuartJobParameters(pickupAt: order.deliveryDate,
                                                        pickups: [chefLocation],
                                                        dropoffs: [dropOff],
                                                        transportType: nil)
                return NetworkService.shared.createStuartJobWith(jobParameters)
                    .flatMap { stuartJob -> Single<Order> in
                        self.setStuartIdWith(orderId: orderId,
                                             stuartId: stuartJob.id)
                            .flatMap { _ -> Single<Order> in
                                self.changeOrderStatusWith(orderId: orderId,
                                                           state: .scheduled)
                            }
                    }
            }
    }

    func setStuartIdWith(orderId: Int64, stuartId: Int64) -> Single<Order> {
        return NetworkService.shared.setStuartIdFor(orderId: orderId, stuartId: stuartId)
    }

    func changeOrderStatusWith(orderId: Int64, state: OrderStates) -> Single<Order> {
        return NetworkService.shared.changeOrderStatusWith(orderId: orderId,
                                                           state: state.rawValue)
    }

}
