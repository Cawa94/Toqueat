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
        1: "06-07",
        2: "07-08",
        3: "08-09",
        4: "09-10",
        5: "10-11",
        6: "11-12",
        7: "12-13",
        8: "13-14",
        9: "14-15",
        10: "15-16",
        11: "16-17",
        12: "17-18",
        13: "18-19",
        14: "19-20",
        15: "20-21",
        16: "21-22",
        17: "22-23"
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

}
