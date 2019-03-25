final class OrdersViewModel: BaseTableViewModel<[Order], Order> {

    init(userId: Int64) {
        let ordersRequest = NetworkService.shared.getOrdersFor(userId: userId)
        super.init(dataSource: ordersRequest)
    }

}
