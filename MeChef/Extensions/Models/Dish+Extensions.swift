import Foundation

extension Dish {

    var imageLink: URL? {
        if let imageUrl = imageUrl {
            return URL(string: "\(NetworkService.baseUrl)\(imageUrl.dropFirst())")
        } else {
            return nil
        }
    }

    var asLocalCartDish: LocalCartDish {
        return LocalCartDish(id: id, name: name, price: price, imageUrl: imageUrl)
    }

    static var new: Dish {
        return Dish(description: "",
                    chef: nil,
                    price: 0.00,
                    imageUrl: nil,
                    id: -1,
                    name: "")
    }

}
