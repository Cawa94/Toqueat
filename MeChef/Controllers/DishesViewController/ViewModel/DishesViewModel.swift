final class DishesViewModel: BaseTableViewModel<[Dish], Dish> {

    init() {
        let dishesRequest = NetworkService.shared.getAllDishes()
        super.init(dataSource: dishesRequest)
    }

    var dishesTypes: [DishType] = [DishType(imageName: "main_dishes",
                                            name: "Main dishes",
                                            sortParams: ["editorial_best"],
                                            isActive: true),
                                   DishType(imageName: "second_dishes",
                                            name: "Second dishes",
                                            sortParams: ["editorial_best"],
                                            isActive: true),
                                   DishType(imageName: "one_dishes",
                                            name: "One dishes",
                                            sortParams: ["editorial_best"],
                                            isActive: true),
                                   DishType(imageName: "snacks",
                                            name: "Snacks",
                                            sortParams: ["editorial_best"],
                                            isActive: true),
                                   DishType(imageName: "desserts",
                                            name: "Desserts",
                                            sortParams: ["editorial_best"],
                                            isActive: true),
                                   DishType(imageName: "salads",
                                            name: "Salads",
                                            sortParams: ["editorial_best"],
                                            isActive: true)]

}
