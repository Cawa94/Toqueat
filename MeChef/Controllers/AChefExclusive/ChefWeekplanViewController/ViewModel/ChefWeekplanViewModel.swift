import Foundation
import RxSwift
import SwiftDate

final class ChefWeekplanViewModel: BaseStatefulViewModel<ChefWeekplanViewModel.ResultType> {

    struct ResultType {
        let orders: [BaseOrder]
        let deliverySlots: [DeliverySlot]
    }

    private let disposeBag = DisposeBag()
    var chefId: Int64
    var chefSlots: [DeliverySlot] = []
    var today = DateInRegion().dateAt(.startOfDay)
    var weekdaysOrdered: [Int64]

    init(chefId: Int64) {
        self.chefId = chefId
        let firstDay = today.weekday != 1 ? today.weekday - 1 : 7
        var tempWeekdays = DeliverySlot.weekdayTable.map { $0.key }.sorted(by: { $0 < $1 })
        if firstDay != 1 { // if not Monday, change order of the days
            let toMoveDays = tempWeekdays[0...firstDay - 2]
            tempWeekdays.removeSubrange(0...firstDay - 2)
            tempWeekdays.append(contentsOf: toMoveDays)
        }
        self.weekdaysOrdered = tempWeekdays

        let ordersRequest = NetworkService.shared.getWeekplanFor(chefId: chefId)
        let slotsRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)

        let zippedRequest = Single.zip(ordersRequest, slotsRequest, resultSelector: {
            ResultType(orders: $0, deliverySlots: $1)
        })
        super.init(dataSource: zippedRequest)
    }

}

extension ChefWeekplanViewModel {

    func elementTitleAt(_ indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            let dayDate = today.dateByAdding(indexPath.row, .day)
            return "\(dayDate.weekdayName(.default).capitalized) \(dayDate.day)"
        default:
            return DeliverySlot.hoursRangeWithIndex(indexPath.section)
        }
    }

    func orderAt(_ indexPath: IndexPath) -> BaseOrder? {
        guard !isLoading
            else { return nil }
        return result.orders.first(where: { $0.deliverySlot.weekdayId == (weekdaysOrdered[indexPath.row])
            && $0.deliverySlot.hourId == (indexPath.section) && $0.orderState != .canceled }) ?? nil
    }

    func isAvailableAt(_ indexPath: IndexPath) -> Bool {
        guard !isLoading
            else { return false }
        return result.deliverySlots.contains(where: { $0.weekdayId == (weekdaysOrdered[indexPath.row])
            && $0.hourId == (indexPath.section) })
    }

    var cellColorForWeekdays: UIColor {
        return .white
    }

    var textColorForWeekdays: UIColor {
        return .mainOrangeColor
    }

    var cellColorForHours: UIColor {
        return .white
    }

    func textColorForAvailability(_ available: Bool) -> UIColor {
        return available ? .mainOrangeColor : .lightGrayColor
    }

    func textColorForOrderCell(state: OrderState) -> UIColor {
        switch state {
        case .waitingForConfirmation:
            return .darkGrayColor
        default:
            return .white
        }
    }

    func cellColorForOrder(state: OrderState) -> UIColor {
        switch state {
        case .waitingForConfirmation:
            return .yellow
        default:
            return .mainOrangeColor
        }
    }

}
