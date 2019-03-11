final class DishesViewModel: BaseTableViewModel<[Dish], Dish> {

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
    }

}
