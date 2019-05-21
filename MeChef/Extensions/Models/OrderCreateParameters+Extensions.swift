import Foundation

extension OrderCreateParameters {

    func copyWith(intentId: String) -> OrderCreateParameters {
        return OrderCreateParameters(userId: userId, dishIds: dishIds, chefId: chefId,
                                     deliveryDate: deliveryDate, deliverySlotId: deliverySlotId,
                                     deliveryAddress: deliveryAddress, deliveryComment: deliveryComment,
                                     dishesPrice: dishesPrice, deliveryPrice: deliveryPrice,
                                     paymentIntentId: intentId)
    }

}
