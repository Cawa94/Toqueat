import Foundation
import SwiftDate
import RxSwift

final class DeliverySlotsViewModel: BaseStatefulViewModel<DeliverySlotsViewModel.ResultType> {

    struct ResultType {
        let orders: [Order]
        let deliverySlots: [DeliverySlot]
    }

    var deliverySlots: [DeliverySlot] = []
    var today = DateInRegion().dateAt(.startOfDay)

    init(chefId: Int64) {
        let ordersRequest = NetworkService.shared.getOrdersFor(chefId: chefId)
        let slotsRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)

        let zippedRequest = Single.zip(ordersRequest, slotsRequest, resultSelector: {
            ResultType(orders: $0, deliverySlots: $1)
        })
        super.init(dataSource: zippedRequest)
    }

}

extension DeliverySlotsViewModel {

    var listOfWeekdaysIds: [Int64] {
        guard !isLoading
            else { return [] }
        let availableWeekdays = deliverySlots.map { $0.weekdayId }.uniqueElements
        let firstDay = today.weekdayOrdinal
        var tempWeekdays = DeliverySlot.weekdayTable.map { $0.key }.sorted(by: { $0 < $1 })
        let toMoveDays = tempWeekdays[0...firstDay - 2]
        tempWeekdays.removeSubrange(0...firstDay - 2)
        tempWeekdays.append(contentsOf: toMoveDays)
        tempWeekdays = tempWeekdays.filter { availableWeekdays.contains($0) }
        return tempWeekdays
    }

    func weekdayNameWith(weekdayId: Int64) -> String {
        guard !isLoading
            else { return "Unknown" }
        let weekdayDate = Date.today().next(weekdayId, considerToday: true)
        return "\(weekdayDate.weekdayName(.short)) \(weekdayDate.day) \(weekdayDate.monthName(.short))"
    }

    func listOfHoursIdsFor(selectedIndex: Int) -> [Int64] {
        guard !isLoading
            else { return [] }
        return deliverySlots
            .filter { $0.weekdayId == listOfWeekdaysIds[selectedIndex] }.map { $0.hourId }
            .sorted(by: { $0 < $1 })
            .uniqueElements
    }

    func hoursRangeWith(hourId: Int64, weekdayId: Int64) -> String {
        guard !isLoading
            else { return "Unknown" }
        return deliverySlots
            .first(where: { $0.weekdayId == weekdayId && $0.hourId == hourId })?.hourRange ?? "Unknown"
    }

    func getDeliverySlotIdWith(hourId: Int64, weekdayId: Int64) -> Int64 {
        return deliverySlots
            .first(where: { $0.weekdayId == weekdayId && $0.hourId == hourId })?.id ?? -1
    }

    func deliveryDate(weekdayId: Int64, hourId: Int64) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let dayComponents = DateComponents(calendar: dateFormatter.calendar, weekday: Int(weekdayId))
        let deliveryDay = dateFormatter.calendar.nextDate(after: Date(),
                                                          matching: dayComponents,
                                                          matchingPolicy: .nextTimePreservingSmallerComponents)
        guard let deliveryDate = deliveryDay?.dateBySet(hour: Int(hourId) + 5, min: nil, secs: nil)
            else { fatalError("Cannot create date") }

        return deliveryDate
    }

}
