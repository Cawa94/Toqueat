import Foundation

final class ChefOrdersViewModel: BaseTableViewModel<[Order], Order> {

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getOrdersFor(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}
