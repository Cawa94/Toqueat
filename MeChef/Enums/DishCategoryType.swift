// swiftlint:disable all
struct DishCategoryType {
    let name: String
    let id: Int64

    static let allValues = [DishCategoryType(name: .dishTypeMainCourses(), id: 1),
                            DishCategoryType(name: .dishTypeSecondCourses(), id: 2),
                            DishCategoryType(name: .dishTypeSingleCourses(), id: 3),
                            DishCategoryType(name: .dishTypeSnacks(), id: 4),
                            DishCategoryType(name: .dishTypeSalads(), id: 5),
                            DishCategoryType(name: .dishTypeDesserts(), id: 6)
    ]

}
