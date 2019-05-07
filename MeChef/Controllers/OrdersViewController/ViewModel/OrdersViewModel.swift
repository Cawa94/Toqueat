import RxSwift

final class OrdersViewModel: BaseTableViewModel<[BaseOrder], BaseOrder> {

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
