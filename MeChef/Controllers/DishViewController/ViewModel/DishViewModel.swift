import Foundation

final class DishViewModel: BaseStatefulViewModel<Dish> {

    let dishId: Int64

    init(dishId: Int64) {
        self.dishId = dishId
        let dishRequest = NetworkService.shared.getDishWith(dishId: dishId)
        super.init(dataSource: dishRequest)
    }

}

extension DishViewModel {

    var baseChef: BaseChef? {
        guard let chefId = result.chef?.id, let chefName = result.chef?.name
            else { return nil }
        return BaseChef(avatarUrl: result.chef?.avatarUrl, id: chefId, name: chefName)
    }

    var chefId: Int64 {
        return isLoading ? -1 : result.chef?.id ?? -1
    }

    var imageUrl: URL? {
        return result.imageLink
    }

    var localCartDish: LocalCartDish {
        return LocalCartDish(id: result.id, name: result.name, price: result.price, imageUrl: result.imageUrl)
    }

}
