import Foundation

final class DishViewModel: BaseStatefulViewModel<Dish> {

    let dishId: Int64

    init(dishId: Int64) {
        self.dishId = dishId
        let dishRequest = NetworkService.shared.getDishWith(id: dishId)
        super.init(dataSource: dishRequest)
    }

}

extension DishViewModel {

    var dishName: String {
        return isLoading ? "LOADING" : result.name
    }

    var dishDescription: String {
        return isLoading ? "LOADING" : result.description
    }

    var chefName: String {
        return isLoading ? "LOADING" : result.chef?.name ?? "Unknown"
    }

    var chefId: Int64 {
        return isLoading ? -1 : result.chef?.id ?? -1
    }

    var imageUrl: URL? {
        return result.imageLink
    }

}
