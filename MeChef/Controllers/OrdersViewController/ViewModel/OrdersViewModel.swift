import RxSwift

final class OrdersViewModel: BaseTableViewModel<[BaseOrder], OrdersViewModel.OrdersSection> {

    struct OrdersSection {
        let state: OrderState
        let orders: [BaseOrder]
    }

    init() {
        var ordersRequest: Single<[BaseOrder]>
        if SessionService.isChef {
            ordersRequest = NetworkService.shared
                .getOrdersFor(chefId: SessionService.session?.chef?.id ?? -1)
        } else {
            ordersRequest = NetworkService.shared
                .getOrdersFor(userId: SessionService.session?.user?.id ?? -1)
        }
        super.init(dataSource: ordersRequest)
    }

}

extension OrdersViewModel {

    var ordersGroupedByState: [OrdersSection] {
        let dictionary = Dictionary.init(grouping: result.sorted(by: { $0.deliveryDate > $1.deliveryDate }),
                                         by: { $0.state })
        let ordersSections = dictionary.compactMap {
            OrdersSection(state: OrderState.getStateFrom($0), orders: $1)
            }.sorted(by: { OrderState.getStateIndexFor($0.state) < OrderState.getStateIndexFor($1.state) })
        return ordersSections
    }

}
