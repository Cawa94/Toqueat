final class DishesViewModel: BaseTableViewModel<[BaseDish], BaseDish> {

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
    }

    var dishesTypes: [DishCategory] = [DishCategory(imageName: "main_dishes",
                                                    name: .dishTypeMainCourses(),
                                                    paramId: 1,
                                                    isActive: false),
                                       DishCategory(imageName: "second_dishes",
                                                    name: .dishTypeSecondCourses(),
                                                    paramId: 2,
                                                    isActive: false),
                                       DishCategory(imageName: "one_dishes",
                                                    name: .dishTypeSingleCourses(),
                                                    paramId: 3,
                                                    isActive: false),
                                       DishCategory(imageName: "snacks",
                                                    name: .dishTypeSnacks(),
                                                    paramId: 4,
                                                    isActive: false),
                                       DishCategory(imageName: "salads",
                                                    name: .dishTypeSalads(),
                                                    paramId: 5,
                                                    isActive: false),
                                       DishCategory(imageName: "desserts",
                                                    name: .dishTypeDesserts(),
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
