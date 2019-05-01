import UIKit

struct OrderTableViewModel {

    let order: Order

}

extension OrderTableViewModel {

    var delivery: String {
        let date = order.deliveryDate
        return "\(date.weekdayName(.default)) \(date.day) \(date.monthName(.default))"
            + " at \(Calendar.current.component(.hour, from: date))"
    }

    func colorFor(_ state: OrderState) -> UIColor {
        switch state {
        case .waitingForConfirmation:
            return .red
        case .scheduled, .enRoute:
            return .mainOrangeColor
        case .delivered:
            return .mainOrangeColor
        case .canceled:
            return .darkGrayColor
        }
    }

}
