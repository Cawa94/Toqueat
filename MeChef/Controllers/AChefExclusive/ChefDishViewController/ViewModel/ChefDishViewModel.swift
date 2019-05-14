import RxSwift

final class ChefDishViewModel: BaseStatefulViewModel<ChefDishViewModel.ResultType> {

    struct ResultType {
        let dish: Dish?
    }

    var isNewDish: Bool

    init(dishId: Int64?) {
        isNewDish = dishId == nil

        let chefRequest = isNewDish
        ? Single.just(ResultType(dish: nil))
        : NetworkService.shared.getDishWith(dishId: dishId ?? -1)
            .map { ResultType(dish: $0) }

        super.init(dataSource: chefRequest)
    }

}
