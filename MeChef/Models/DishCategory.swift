struct DishCategory {

    var imageName: String
    var name: String
    var paramId: Int64
    var isActive: Bool

    init(imageName: String,
         name: String,
         paramId: Int64,
         isActive: Bool = false) {
        self.imageName = imageName
        self.name = name
        self.paramId = paramId
        self.isActive = isActive
    }

}
