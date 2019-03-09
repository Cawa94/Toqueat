final class DishesViewModel: BaseTableViewModel<[Dish], Dish> {

    private let dishesPlaceholders = [
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING"),
        Dish(description: "LOADING", chef: BaseResultWithIdAndName(id: -1, name: ""), id: -1, name: "LOADING")
    ]

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
        placeholderElements = dishesPlaceholders
    }

}
