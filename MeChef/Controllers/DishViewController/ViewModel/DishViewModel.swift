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
        return isLoading
            ? nil : result.chef
    }

    var chefId: Int64 {
        return isLoading ? -1 : result.chef.id
    }

    var imageUrl: URL? {
        return result.imageLink
    }

    var localCartDish: LocalCartDish {
        return LocalCartDish(id: result.id, name: result.name,
                             price: result.price, imageUrl: result.imageUrl,
                             maxQuantity: result.maxQuantity,
                             containerVolume: result.containerVolume)
    }

}
