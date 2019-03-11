import Foundation

final class DishViewModel: BaseStatefulViewModel<Dish> {

    init(dishId: Int64) {
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

    var imageUrl: URL? {
        return result.imageLink
    }

}
