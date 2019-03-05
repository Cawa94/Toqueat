final class DishesViewModel: BaseTableViewModel<[Dish], Dish> {

    private let dishesPlaceholders = [
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING"),
        Dish(id: -1, name: "LOADING", description: "LOADING")
    ]

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
        placeholderElements = dishesPlaceholders
    }

}
