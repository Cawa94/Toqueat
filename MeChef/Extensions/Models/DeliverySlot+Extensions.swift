import Foundation

extension DeliverySlot {

    static var all: [Int64: [DeliverySlot]] {
        var index = Int64(1)
        var allSlots: [Int64: [DeliverySlot]] = [:]
        for day in weekdayTable.sorted(by: { $0.key < $1.key }) {
            var daySlots: [DeliverySlot] = []
            for hour in hoursTable.sorted(by: { $0.key < $1.key }) {
                let slot = DeliverySlot(id: index, weekdayId: day.key, hourId: hour.key)
                daySlots.append(slot)
                index += 1
            }
            allSlots[day.key] = daySlots
        }
        return allSlots
    }

    static let weekdayTable: [Int64: String] = [
        1: .commonMonday(),
        2: .commonTuesday(),
        3: .commonWednesday(),
        4: .commonThursday(),
        5: .commonFriday(),
        6: .commonSaturday(),
        7: .commonSunday()
    ]

    static let hoursTable: [Int64: String] = [
        1: "09:00-10:00",
        2: "10:00-11:00",
        3: "11:00-12:00",
        4: "12:00-13:00",
        5: "13:00-14:00",
        6: "14:00-15:00",
        7: "15:00-16:00",
        8: "16:00-17:00",
        9: "17:00-18:00",
        10: "18:00-19:00",
        11: "19:00-20:00",
        12: "20:00-21:00",
        13: "21:00-22:00",
        14: "22:00-23:00"
    ]

    var weekday: String {
        return DeliverySlot.weekdayTable[weekdayId] ?? "Unknown"
    }

    var hourRange: String {
        return DeliverySlot.hoursTable[hourId] ?? "Unknown"
    }

    var deliveryTime: String {
        return "\(weekday) at \(hourRange)"
    }

    static func weekdayWithIndex(_ index: Int) -> String {
        return weekdayTable[Int64(index)] ?? "Unknown"
    }

    static func hoursRangeWithIndex(_ index: Int) -> String {
        return hoursTable[Int64(index)] ?? "Unknown"
    }

    static func weekdayWithId(_ weekdayId: Int64) -> String {
        return weekdayTable[weekdayId] ?? "Unknown"
    }

    static func hoursRangeWithId(_ hourId: Int64) -> String {
        return hoursTable[hourId] ?? "Unknown"
    }

    func attributedDeliveryMessage(with date: Date) -> NSAttributedString {
        return NSMutableAttributedString()
            .normal("\(String.deliveryDateWillReceive()) ", size: 15.0)
            .bold("\(weekday) \(date.day) \(date.monthName(.default).capitalized)", size: 15.0)
            .normal(" \(String.commonBetween().lowercased()) ", size: 15.0)
            .bold(hourRange, size: 15.0)
    }

}

extension DeliverySlot: Equatable {

    static func == (lhs: DeliverySlot, rhs: DeliverySlot) -> Bool {
        return lhs.id == rhs.id
    }

}
