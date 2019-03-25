import Foundation

struct OrderTableViewModel {

    let order: Order

    init(order: Order) {
        self.order = order
    }

}

extension OrderTableViewModel {

    var delivery: String {
        let date = order.deliveryDate
        return "\(date.weekdayName(.default)) \(date.day) \(date.monthName(.default))"
            + " at \(Calendar.current.component(.hour, from: date))"
    }

}
