import Foundation

extension DeliverySlot {

    static let weekdayTable: [Int64: String] = [
        1: "Monday",
        2: "Tuesday",
        3: "Wednesday",
        4: "Thursday",
        5: "Friday",
        6: "Saturday",
        7: "Sunday"
    ]

    static let hoursTable: [Int64: String] = [
        1: "06:00-07:00",
        2: "07:00-08:00",
        3: "08:00-09:00",
        4: "09:00-10:00",
        5: "10:00-11:00",
        6: "11:00-12:00",
        7: "12:00-13:00",
        8: "13:00-14:00",
        9: "14:00-15:00",
        10: "15:00-16:00",
        11: "16:00-17:00",
        12: "17:00-18:00",
        13: "18:00-19:00",
        14: "19:00-20:00",
        15: "20:00-21:00",
        16: "21:00-22:00",
        17: "22:00-23:00"
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

}
