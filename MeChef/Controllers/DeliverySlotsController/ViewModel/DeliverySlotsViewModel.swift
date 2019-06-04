import Foundation
import SwiftDate
import RxSwift

final class DeliverySlotsViewModel: BaseStatefulViewModel<DeliverySlotsViewModel.ResultType> {

    struct ResultType {
        let deliverySlots: [DeliverySlot]
        let slotsIdsBusy: [Int64]
    }

    private let disposeBag = DisposeBag()
    var chefId: Int64
    var selectedSlot: DeliverySlot?
    var today = DateInRegion().dateAt(.startOfDay)
    var weekdaysOrdered: [Int64]

    init(chefId: Int64) {
        self.chefId = chefId
        let weekdays = [1, 2, 3, 4, 5, 6, 7]
        let firstDayIndex = (today.weekday != 1 ? today.weekday - 1 : 7) - 1
        let firstDay = weekdays[cyclic: firstDayIndex /*+ 2*/]
        var tempWeekdays = DeliverySlot.weekdayTable.map { $0.key }.sorted(by: { $0 < $1 })
        if firstDay != 1 { // if not Monday, change order of the days
            let toMoveDays = tempWeekdays[0...firstDay - 2]
            tempWeekdays.removeSubrange(0...firstDay - 2)
            tempWeekdays.append(contentsOf: toMoveDays)
        }
        self.weekdaysOrdered = tempWeekdays

        let slotsRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)
        let slotsBusyRequest = NetworkService.shared.getDeliverySlotBusyIdsFor(chefId: chefId)

        let combinedSingle = Single.zip(slotsRequest, slotsBusyRequest) {
            return ResultType(deliverySlots: $0, slotsIdsBusy: $1)
        }

        super.init(dataSource: combinedSingle)
    }

}

extension DeliverySlotsViewModel {

    func elementTitleAt(_ indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            let dayDate = today.dateByAdding(indexPath.row /*+ 2*/, .day)
            return "\(dayDate.weekdayName(.default).capitalized) \(dayDate.day)"
        default:
            return DeliverySlot.hoursRangeWithIndex(indexPath.section)
        }
    }

    func deliverySlotAt(_ indexPath: IndexPath) -> DeliverySlot {
        guard let deliverySlot = DeliverySlot.all[weekdaysOrdered[cyclic: indexPath.row]]?[indexPath.section - 1]
            else { fatalError("Cannot find delivery slot") }
        return deliverySlot
    }

    func deliveryDate(weekdayId: Int64, hourId: Int64) -> Date {
        let deliveryDay = Date().next(weekdayId + 1)
        guard let deliveryDate = deliveryDay.dateBySet(hour: Int(hourId) + 8, min: nil, secs: nil)
            else { fatalError("Cannot create date") }
        debugPrint(deliveryDate)
        return deliveryDate
    }

    func isAvailableAt(_ indexPath: IndexPath) -> Bool {
        guard !isLoading
            else { return false }
        return result.deliverySlots.contains(where: { $0.weekdayId == (weekdaysOrdered[indexPath.row])
            && $0.hourId == (indexPath.section) })
    }

    func hasAnOrderWith(slotId: Int64) -> Bool {
        guard !isLoading
            else { return false }
        return result.slotsIdsBusy.contains(where: { $0 == slotId })
    }

    var cellColorForWeekdays: UIColor {
        return .white
    }

    var textColorForWeekdays: UIColor {
        return .mainOrangeColor
    }

    func cellColorForHours(isSelected: Bool, hasOrder: Bool) -> UIColor {
        if hasOrder {
            return .red
        }
        return isSelected ? .mainOrangeColor : .white
    }

    func textColorForAvailability(_ available: Bool, isSelected: Bool, hasOrder: Bool) -> UIColor {
        if isSelected || hasOrder {
            return .white
        }
        return available ? .mainOrangeColor : .lightGrayColor
    }

}
