import Foundation
import RxSwift

final class CheckoutViewModel: BaseStatefulViewModel<CheckoutViewModel.ResultType> {

    struct ResultType {
        let chef: Chef
        let deliveryCost: NSDecimalNumber
    }

    var cart: LocalCart
    var chefId: Int64

    init(cart: LocalCart, chefId: Int64) {
        self.cart = cart
        self.chefId = chefId
        let chefRequestSingle = NetworkService.shared.getChefWith(chefId: chefId)
        let deliveryCostSingle = chefRequestSingle.flatMap { chef in
            return NetworkService.shared
                .getDeliveryCost(pickupAt: cart.deliveryDate,
                                 userAddress: SessionService.session?.user?.fullAddress ?? "",
                                 userComment: SessionService.session?.user?.apartment,
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
                                     packageType: "small",
                                     packageDescription: "",
                                     clientReference: nil)
        let jobParameters = StuartJobParameters(pickupAt: pickupAt,
                                                pickups: [pickup],
                                                dropoffs: [dropOff],
                                                transportType: nil)
        return NetworkService.shared.getStuartJobPriceWith(jobParameters)
    }

}
