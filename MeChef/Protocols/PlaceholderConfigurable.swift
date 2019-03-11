import UIKit

enum ContentLoadingViewModel<ContentType, PlaceholderType> {

    case placeholder(placeholderViewModel: PlaceholderType)
    case content(contentViewModel: ContentType)

}

extension ContentLoadingViewModel {

    var isPlaceholder: Bool {
        if case .placeholder = self {
            return true
        } else {
            return false
        }
    }

}

extension ContentLoadingViewModel where PlaceholderType == Void {

    static var placeholder: ContentLoadingViewModel<ContentType, PlaceholderType> {
        return .placeholder(placeholderViewModel: ())
    }

}

extension ContentLoadingViewModel where PlaceholderType == [Void] {

    static func placeholders(numberOfItems: Int) -> ContentLoadingViewModel<ContentType, PlaceholderType> {
        return .placeholder(placeholderViewModel: Array(repeating: (), count: numberOfItems))
    }

}

protocol PlaceholderConfigurable {

    var contentContainerView: UIView { get }
    var placeholderContainerView: UIView { get }

    associatedtype ContentViewModelType
    associatedtype PlaceholderViewModelType

    typealias ContentLoadingViewModelType = ContentLoadingViewModel<ContentViewModelType, PlaceholderViewModelType>

    func configureContentLoading(with placeholderViewModel: ContentLoadingViewModelType)

    func configure(contentViewModel: ContentViewModelType)
    func configure(placeholderViewModel: PlaceholderViewModelType)

}

extension PlaceholderConfigurable {

    func configureContentLoading(with contentLoadingViewModel: ContentLoadingViewModelType) {
        switch contentLoadingViewModel {

        case .content(let contentViewModel):
            configure(contentViewModel: contentViewModel)

        case .placeholder(let placeholderViewModel):
            configure(placeholderViewModel: placeholderViewModel)
        }

        contentContainerView.isHidden = contentLoadingViewModel.isPlaceholder
        placeholderContainerView.isHidden = !contentLoadingViewModel.isPlaceholder
    }

    func configure(placeholderViewModel: PlaceholderViewModelType) {
        // typically nothing
    }

    static func content(with contentViewModel: ContentViewModelType) -> ContentLoadingViewModelType {
        return ContentLoadingViewModelType.content(contentViewModel: contentViewModel)
    }

}
