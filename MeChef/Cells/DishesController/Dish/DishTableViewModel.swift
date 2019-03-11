struct DishTableViewModel {

    let dish: Dish
    let chefName: String?

    init(dish: Dish,
         chefName: String?) {
        self.dish = dish
        self.chefName = chefName
    }

}
