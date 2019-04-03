struct DishTableViewModel {

    let dish: Dish
    let chef: BaseChef?

    init(dish: Dish,
         chef: BaseChef?) {
        self.dish = dish
        self.chef = chef
    }

}
