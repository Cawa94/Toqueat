extension LocalCartDish {

    var asDish: Dish {
        return Dish(description: "", chef: nil, price: price, imageUrl: imageUrl, id: id, name: name)
    }

}
