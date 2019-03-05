struct ChefViewModel {

    var chef: Chef

}

extension ChefViewModel {

    var chefDishes: [Dish] {
        return chef.dishes ?? []
    }

}
