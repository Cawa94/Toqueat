import RxSwift
import RxCocoa
import LeadKit

private struct Constants {
    static var placeholderElements = 4
}

class BaseTableViewModel<ResultType, ElementType>: BaseStatefulViewModel<ResultType> {

    var elements: [ElementType] = []

}

extension BaseTableViewModel {

    func numberOfItems(for section: Int) -> Int {
        return hasContent ? elements.count : Constants.placeholderElements
    }

    func elementAt(_ index: Int) -> ElementType {
        return elements[index]
    }

}
