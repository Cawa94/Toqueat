import Foundation
import RxSwift
import SwiftDate

final class ChefOrderDetailsViewModel: BaseTableViewModel<Order, LocalCartDish> {

    init(orderId: Int64) {
        let orderRequest = NetworkService.shared.getOrderWith(orderId: orderId)
        super.init(dataSource: orderRequest)
    }

}

extension ChefOrderDetailsViewModel {

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
                                             clientReference: "\(orderId)")
                let jobParameters = StuartJobParameters(pickupAt: nil /*order.deliveryDate*/,
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

    func changeOrderStatusWith(orderId: Int64, state: OrderState) -> Single<Order> {
        return NetworkService.shared.changeOrderStatusWith(orderId: orderId,
                                                           state: state.rawValue)
    }

    func quantityOf(dish: LocalCartDish) -> Int {
        return result.dishes.filter { $0.id == dish.id }.count
    }

}
