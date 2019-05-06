// swiftlint:disable all
struct DishCategoryType {
    let name: String
    let id: Int64

    static let allValues = [DishCategoryType(name: "Main Course", id: 1),
                            DishCategoryType(name: "Second Course", id: 2),
                            DishCategoryType(name: "One Course", id: 3),
                            DishCategoryType(name: "Snack", id: 4),
                            DishCategoryType(name: "Salad", id: 5),
                            DishCategoryType(name: "Dessert", id: 6)
    ]

}
