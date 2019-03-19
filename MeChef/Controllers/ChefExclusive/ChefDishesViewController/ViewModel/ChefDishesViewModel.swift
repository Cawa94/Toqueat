import Foundation

final class ChefDishesViewModel: BaseTableViewModel<Chef, Dish> {

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}
