import Foundation
import RxSwift
import Stripe

final class CheckoutViewModel: BaseStatefulViewModel<CheckoutViewModel.ResultType> {

    // Parameters
    let packageSize = "medium"

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
                                 chef: chef)
        }

        let combinedSingle = Single.zip(chefRequestSingle, deliveryCostSingle) {
            ResultType(chef: $0, deliveryCost: $1)
        }

        super.init(dataSource: combinedSingle)
    }

}

extension CheckoutViewModel {

    func getDeliveryCost(pickupAt: Date?,
                         userAddress: String,
                         userComment: String?,
                         chef: Chef) -> Single<NSDecimalNumber> {
        let pickup = chef.stuartLocation
        let dropOff = StuartLocation(address: userAddress,
                                     comment: userComment,
                                     contact: nil,
                                     packageType: packageSize,
                                     packageDescription: "",
                                     clientReference: nil)
        let jobParameters = StuartJobParameters(pickupAt: pickupAt,
                                                pickups: [pickup],
                                                dropoffs: [dropOff],
                                                transportType: nil)
        return NetworkService.shared.getStuartJobPriceWith(jobParameters)
    }

    func createStuartJobWith(orderId: Int64, chefLocation: StuartLocation) -> Single<Order> {
        let networkService = NetworkService.shared
        return networkService.getOrderWith(orderId: orderId)
            .flatMap { order -> Single<Order> in
                guard order.stuartId == nil
                    else { return Single.just(order) }
                let dropOff = StuartLocation(address: order.deliveryAddress,
                                             comment: order.deliveryComment,
                                             contact: SessionService.session?.user?.stuartContact,
                                             packageType: self.packageSize,
                                             packageDescription: "",
                                             clientReference: "\(orderId)")
                let fixedStuartDate = order.deliveryDate.dateByAdding(-4, .hour).date
                let jobParameters = StuartJobParameters(pickupAt: fixedStuartDate, // nil
                                                        pickups: [chefLocation],
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
