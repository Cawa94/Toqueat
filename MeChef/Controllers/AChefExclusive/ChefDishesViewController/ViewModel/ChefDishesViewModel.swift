import Foundation

final class ChefDishesViewModel: BaseTableViewModel<Chef, ChefDish> {

    var chefId: Int64

    init(chefId: Int64) {
        self.chefId = chefId
        let chefRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}
