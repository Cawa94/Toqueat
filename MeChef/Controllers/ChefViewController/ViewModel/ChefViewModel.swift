final class ChefViewModel: BaseTableViewModel<Chef, Dish> {

    private let dishesPlaceholders = [
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING")
    ]

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(id: chefId)
        super.init(dataSource: chefRequest)
        placeholderElements = dishesPlaceholders
    }

}

extension ChefViewModel {

    var chefName: String {
        return isLoading ? "LOADING" : result.name
    }

}
