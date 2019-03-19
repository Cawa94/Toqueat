import Foundation
import SwiftDate

final class DeliverySlotsViewModel: BaseStatefulViewModel<[DeliverySlot]> {

    var deliverySlots: [DeliverySlot] = []

    init(chefId: Int64) {
        let slotsRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)
        super.init(dataSource: slotsRequest)
    }

}

extension DeliverySlotsViewModel {

    var listOfWeekdaysIds: [Int64] {
        guard !isLoading
            else { return [] }
        return deliverySlots.map { $0.weekdayId }.uniqueElements
    }

    func weekdayNameWith(weekdayId: Int64) -> String {
        guard !isLoading
            else { return "Unknown" }
        let calendar = Calendar(identifier: .gregorian)
        let dayComponents = DateComponents(calendar: calendar, weekday: Int(weekdayId))
        guard let weekdayDate = calendar.nextDate(after: Date(),
                                                  matching: dayComponents,
                                                  matchingPolicy: .nextTimePreservingSmallerComponents)
            else { return "Unknown" }
        return "\(weekdayDate.weekdayName(.short)) \(weekdayDate.day) \(weekdayDate.monthName(.short))"
    }

    func listOfHoursIdsFor(selectedIndex: Int) -> [Int64] {
        guard !isLoading
            else { return [] }
        return deliverySlots
            .filter { $0.weekdayId == listOfWeekdaysIds[selectedIndex] }.map { $0.hourId }
    }

    func hoursRangeWith(hourId: Int64, weekdayId: Int64) -> String {
        guard !isLoading
            else { return "Unknown" }
        return deliverySlots
            .first(where: { $0.weekdayId == weekdayId && $0.hourId == hourId })?.hourRange ?? "Unknown"
    }

}
