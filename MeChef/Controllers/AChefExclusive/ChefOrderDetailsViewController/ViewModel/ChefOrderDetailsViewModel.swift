import Foundation
import RxSwift
import SwiftDate

struct ChefOrderDetailsViewModel {

    let order: Order

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
                                             clientReference: nil)
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

    var elements: [LocalCartDish] {
        return order.dishes.map { $0.asLocalCartDish }.uniqueElements
    }

    func quantityOf(dish: LocalCartDish) -> Int {
        return order.dishes.filter { $0.id == dish.id }.count
    }

    func elementAt(_ index: Int) -> LocalCartDish {
        return elements[index]
    }

}
