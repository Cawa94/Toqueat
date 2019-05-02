import Foundation

extension LocalCartDish {

    var asDish: Dish {
        return Dish(description: "", chef: nil, price: price, imageUrl: imageUrl, id: id, name: name)
    }

    var imageLink: URL? {
        if let imageUrl = imageUrl {
            return URL(string: "\(NetworkService.baseUrl)\(imageUrl.dropFirst())")
        } else {
            return nil
        }
    }

    var quantityInCart: Int {
        guard let cart = CartService.localCart, let dishes = cart.dishes
            else { return 0 }
        return dishes.filter { $0.id == self.id }.count
    }

}

extension LocalCartDish: Equatable {

    static func == (lhs: LocalCartDish, rhs: LocalCartDish) -> Bool {
        return lhs.id == rhs.id
    }

}
