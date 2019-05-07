final class ChefDishViewModel: BaseStatefulViewModel<Dish> {

    var isNewDish: Bool

    init(dishId: Int64?) {
        isNewDish = dishId == nil
        let chefRequest = NetworkService.shared.getDishWith(dishId: dishId ?? -1)
        super.init(dataSource: chefRequest)
    }

}
