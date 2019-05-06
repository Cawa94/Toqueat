final class DishesViewModel: BaseTableViewModel<[Dish], Dish> {

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
    }

    var dishesTypes: [DishCategory] = [DishCategory(imageName: "main_dishes",
                                                    name: "Main courses",
                                                    paramId: 1,
                                                    isActive: false),
                                       DishCategory(imageName: "second_dishes",
                                                    name: "Second courses",
                                                    paramId: 2,
                                                    isActive: false),
                                       DishCategory(imageName: "one_dishes",
                                                    name: "One courses",
                                                    paramId: 3,
                                                    isActive: false),
                                       DishCategory(imageName: "snacks",
                                                    name: "Snacks",
                                                    paramId: 4,
                                                    isActive: false),
                                       DishCategory(imageName: "salads",
                                                    name: "Salads",
                                                    paramId: 5,
                                                    isActive: false),
                                       DishCategory(imageName: "desserts",
                                                    name: "Desserts",
                                                    paramId: 6,
                                                    isActive: false)]

    func deselectFilters() {
        dishesTypes[0].isActive = false
        dishesTypes[1].isActive = false
        dishesTypes[2].isActive = false
        dishesTypes[3].isActive = false
        dishesTypes[4].isActive = false
        dishesTypes[5].isActive = false
    }

}
