struct ChefOrderTableViewModel {

    let order: Order

    init(order: Order) {
        self.order = order
    }

}

extension ChefOrderTableViewModel {

    var delivery: String {
        return "\(order.deliverySlot.deliveryTime) \(order.monthday ?? "")"
    }

}
