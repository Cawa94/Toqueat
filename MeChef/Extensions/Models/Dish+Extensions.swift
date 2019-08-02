import Foundation

extension BaseDish {

    var imageLink: URL? {
        if let imageUrl = imageUrl {
            return URL(string: "\(NetworkService.baseUrl)\(imageUrl.dropFirst())")
        } else {
            return nil
        }
    }

    var asLocalCartDish: LocalCartDish {
        return LocalCartDish(id: id, name: name, price: price,
                             imageUrl: imageUrl, maxQuantity: maxQuantity,
                             containerVolume: containerVolume,
                             minContainerSize: minContainerSize)
    }

}

extension ChefDish {

    var imageLink: URL? {
        if let imageUrl = imageUrl {
            return URL(string: "\(NetworkService.baseUrl)\(imageUrl.dropFirst())")
        } else {
            return nil
        }
    }

    var asLocalCartDish: LocalCartDish {
        return LocalCartDish(id: id, name: name, price: price,
                             imageUrl: imageUrl, maxQuantity: maxQuantity,
                             containerVolume: containerVolume,
                             minContainerSize: minContainerSize)
    }

}
