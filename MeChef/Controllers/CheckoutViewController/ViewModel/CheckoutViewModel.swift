import Foundation
import RxSwift
import Stripe

final class CheckoutViewModel: BaseStatefulViewModel<CheckoutViewModel.ResultType> {

    struct ResultType {
        let chef: Chef
        let deliveryCost: NSDecimalNumber
    }

    var cart: LocalCart
    var chefId: Int64
    var orderParameters: OrderCreateParameters?
    var paymentContext: STPPaymentContext?
    var redirectContext: STPRedirectContext?
    var paymentIntentId: String?

    init(cart: LocalCart, chefId: Int64) {
        self.cart = cart
        self.chefId = chefId

        if let customerContext = StripeService.customerContext {
            self.paymentContext = STPPaymentContext(customerContext: customerContext)
        }

        let chefRequestSingle = NetworkService.shared.getChefWith(chefId: chefId)
        let deliveryCostSingle = chefRequestSingle.flatMap { chef in
            return NetworkService.shared
                .getDeliveryCost(pickupAt: cart.deliveryDate,
                                 userAddress: SessionService.session?.user?.fullAddress ?? "",
                                 userComment: SessionService.session?.user?.stuartComment,
                                 chef: chef,
                                 orderVolume: cart.orderVolume,
                                 minContainer: cart.minContainer)
        }

        let combinedSingle = Single.zip(chefRequestSingle, deliveryCostSingle) {
            ResultType(chef: $0, deliveryCost: $1)
        }

        super.init(dataSource: combinedSingle)
    }

}

extension CheckoutViewModel {

    func createStuartJobWith(orderId: Int64) -> Single<Order> {
        let networkService = NetworkService.shared
        return networkService.getOrderWith(orderId: orderId)
            .flatMap { order -> Single<Order> in
                guard order.stuartId == nil
                    else { return Single.just(order) }
                let dropOff = StuartLocation(
                    address: order.deliveryAddress,
                    comment: order.deliveryComment,
                    contact: SessionService.session?.user?.stuartContact,
                    packageType: StuartContainer.getContainerFor(volume: self.cart.orderVolume,
                                                                 minContainer: self.cart.minContainer)?.rawValue,
                    packageDescription: "",
                    clientReference: "\(orderId)")
                let fixedStuartDate = order.deliveryDate.dateByAdding(-4, .hour).date
                let jobParameters = StuartJobParameters(pickupAt: nil, //fixedStuartDate,
                                                        pickups: [self.result.chef.stuartLocation],
                                                        dropoffs: [dropOff],
                                                        transportType: nil)
                return NetworkService.shared.createStuartJobWith(jobParameters)
                    .flatMap { stuartJob -> Single<Order> in
                        networkService.setStuartIdFor(orderId: orderId, stuartId: stuartJob.id)
                            .flatMap { _ -> Single<Order> in
                                return networkService.changeOrderStatusWith(orderId: orderId,
                                                                            state: .scheduled)
                        }
                }
        }
    }

}
