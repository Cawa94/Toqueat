import Foundation
import UIKit

final class ChefDeliverySlotsViewModel: BaseStatefulViewModel<[DeliverySlot]> {

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension ChefDeliverySlotsViewModel {

    func elementAt(_ indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return DeliverySlot.weekdayWithIndex(indexPath.row + 1)
        default:
            return DeliverySlot.hoursRangeWithIndex(indexPath.section + 2)
        }
    }

    func isAvailableAt(_ indexPath: IndexPath) -> Bool {
        return result.contains(where: { $0.weekdayId == (indexPath.row + 1)
            && $0.hourId == (indexPath.section + 2) })
    }

    func colorForAvailability(_ available: Bool) -> UIColor {
        return available ? .green : .red
    }

}
