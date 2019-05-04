final class ChefDishViewModel: BaseStatefulViewModel<[Category]> {

    let dish: Dish?
    let chefId: Int64

    init(dish: Dish?, chefId: Int64) {
        self.dish = dish
        self.chefId = chefId

        let categoriesRequest = NetworkService.shared.getAllDishesCategories()
        super.init(dataSource: categoriesRequest)
    }

}
