import Foundation

final class DeliverySlotsViewModel: BaseStatefulViewModel<Chef> {

    var deliverySlots: [DeliverySlot] = []

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(id: chefId)
        super.init(dataSource: chefRequest)
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
        return deliverySlots.first(where: { $0.weekdayId == weekdayId })?.weekday ?? "Unknown"
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
