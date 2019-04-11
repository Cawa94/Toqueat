import UIKit

final class ChefsViewModel: BaseStatefulViewModel<[Chef]> {

    enum Constants {
        static let numberOfColumns = 2
        static let placeholderElements = 6
        static let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let horizontalSpacingBetweenCells: CGFloat = 10
        static let cellHeight: CGFloat = 230
    }

    init() {
        let chefsRequest = NetworkService.shared.getAllChefs()
        super.init(dataSource: chefsRequest)
    }

    var elements: [Chef] = []

}

extension ChefsViewModel {

    func numberOfItems(for section: Int) -> Int {
        return hasContent ? elements.count : Constants.placeholderElements
    }

    func elementAt(_ index: Int) -> Chef {
        return elements[index]
    }

}
