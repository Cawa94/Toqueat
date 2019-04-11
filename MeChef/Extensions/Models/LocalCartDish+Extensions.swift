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

}
