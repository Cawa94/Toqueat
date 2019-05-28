import UIKit

struct OrderTableViewModel {

    let order: BaseOrder

}

extension OrderTableViewModel {

    var delivery: String {
        let date = order.deliveryDate
        return "\(date.weekdayName(.default)) \(date.day) \(date.monthName(.default))"
            + " at \(Calendar.current.component(.hour, from: date))"
    }

}
