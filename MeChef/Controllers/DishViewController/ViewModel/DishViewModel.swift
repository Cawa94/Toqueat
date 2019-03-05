final class DishViewModel: BaseStatefulViewModel<Dish> {

    init(dishId: Int64) {
        let dishRequest = NetworkService.shared.getDishWith(id: dishId)
        super.init(dataSource: dishRequest)
    }

}
