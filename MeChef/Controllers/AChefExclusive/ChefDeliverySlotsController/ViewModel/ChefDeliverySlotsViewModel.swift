import Foundation
import UIKit

final class ChefDeliverySlotsViewModel: BaseStatefulViewModel<[DeliverySlot]> {

    let chefId: Int64
    let editable: Bool
    var activeSlots: [DeliverySlot] = []

    init(chefId: Int64, editable: Bool) {
        self.chefId = chefId
        self.editable = editable
        let chefRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension ChefDeliverySlotsViewModel {

    func elementAt(_ indexPath: IndexPath) -> DeliverySlot {
        let deliverySlot = DeliverySlot.all[Int64(indexPath.row + 1)]?[indexPath.section - 1]
            ?? DeliverySlot(id: -1, weekdayId: -1, hourId: -1)
        return deliverySlot
    }

    func elementTitleAt(_ indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return DeliverySlot.weekdayWithIndex(indexPath.row + 1)
        default:
            return DeliverySlot.hoursRangeWithIndex(indexPath.section)
        }
    }

    func isAvailableAt(_ indexPath: IndexPath) -> Bool {
        return activeSlots.contains(where: { $0.weekdayId == (indexPath.row + 1)
            && $0.hourId == (indexPath.section) })
    }

    var cellColorForWeekdays: UIColor {
        return .white
    }

    var textColorForWeekdays: UIColor {
        return .mainOrangeColor
    }

    func cellColorForAvailability(_ available: Bool) -> UIColor {
        if !editable {
            return .white
        }
        return available ? .mainOrangeColor : .white
    }

    func textColorForAvailability(_ available: Bool) -> UIColor {
        return available ? .mainOrangeColor : .lightGrayColor
    }

    func toggle(slot: DeliverySlot) {
        if let activeSlot = activeSlots.enumerated().first(where: { $0.element.weekdayId == slot.weekdayId
                                                                    && $0.element.hourId == slot.hourId }) {
            activeSlots.remove(at: activeSlot.offset)
        } else {
            activeSlots.append(slot)
        }
    }

}
