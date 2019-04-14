import Foundation
import RxSwift

final class CheckoutViewModel: BaseTableViewModel<Chef, LocalCartDish> {

    var cart: LocalCart
    var chefId: Int64

    init(cart: LocalCart, chefId: Int64) {
        self.cart = cart
        self.chefId = chefId
        let chefRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension CheckoutViewModel {

    func getDeliveryCost(pickupAt: Date?,
                         userAddress: String,
                         userComment: String?) -> Single<NSDecimalNumber> {
        guard !isLoading
            else { return Single.just(0.00) }
        let pickup = result.stuartLocation
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
