import UIKit

final class ChefViewModel: BaseStatefulViewModel<Chef> {

    enum Constants {
        static let numberOfColumns = 2
        static let placeholderElements = 6
        static let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let horizontalSpacingBetweenCells: CGFloat = 10
        static let cellHeight: CGFloat = 180
    }

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

    var elements: [ChefDish] = []

}

extension ChefViewModel {

    func numberOfItems(for section: Int) -> Int {
        return hasContent ? elements.count : Constants.placeholderElements
    }

    func elementAt(_ index: Int) -> ChefDish {
        return elements[index]
    }

    var chefName: String {
        return isLoading ? "LOADING" : result.name
    }

    var cityName: String {
        return isLoading ? "LOADING" : result.city.name
    }

    var avatarUrl: URL? {
        if let avatarUrl = result.avatarUrl {
            return URL(string: "\(NetworkService.baseUrl)\(avatarUrl.dropFirst())")
        } else {
            return nil
        }
    }

}
