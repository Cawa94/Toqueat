final class CartViewModel: BaseTableViewModel<Order, Dish> {

    init(userId: Int64) {
        let orderRequest = NetworkService.shared.getOrderWith(id: userId)
        super.init(dataSource: orderRequest)
    }

}
