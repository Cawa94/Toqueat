final class ChefViewModel: BaseTableViewModel<Chef, Dish> {

    private let dishesPlaceholders = [
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING")
    ]

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(id: chefId)
        super.init(dataSource: chefRequest)
        placeholderElements = dishesPlaceholders
    }

}

extension ChefViewModel {

    var chefName: String {
        return isLoading ? "LOADING" : result?.name ?? "Unknown"
    }

}
