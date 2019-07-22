import UIKit
import RxSwift

struct DishDetailsTableViewModel {

    let dish: Dish
    let descriptionExpanded: Bool

}

final class DishDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var readMore: UIButton!
    @IBOutlet private weak var categoryServingsLabel: UILabel!
    @IBOutlet private weak var ingredientsText: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var addToCartView: AddToCartView!

    var viewModel: DishDetailsTableViewModel?
    var disposeBag = DisposeBag()

    public var addToCartButton: UIButton {
        return addToCartView.addButton
    }

    public var addOneToCartButton: UIButton {
        return addToCartView.addOne
    }

    public var removeOneFromCartButton: UIButton {
        return addToCartView.removeOne
    }

    public var readMoreButton: UIButton {
        return readMore
    }

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}

extension DishDetailsTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = DishDetailsTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: DishDetailsTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: DishDetailsTableViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.dish.name
        descriptionTextView.text = contentViewModel.dish.description
        if contentViewModel.descriptionExpanded {
            descriptionTextView.translatesAutoresizingMaskIntoConstraints = true
            descriptionTextView.sizeToFit()
        }
        readMore.isHidden = contentViewModel.descriptionExpanded
            || descriptionTextView.frame.height >
            descriptionTextView.sizeThatFits(descriptionTextView.bounds.size).height
        let addButtonModel = AddToCartViewModel(dish: contentViewModel.dish)
        addToCartView.configureWith(addButtonModel)
        let dishType = DishCategoryType.allValues
            .first(where: { $0.id == contentViewModel.dish.categories?.first?.id })?.name
        categoryServingsLabel.text = "\(dishType ?? "") "
            + "- \(contentViewModel.dish.servings ?? 1) \(String.dishServings().lowercased())"
        if let ingredients = contentViewModel.dish.ingredients?.replacingOccurrences(of: ",",
                                                                                     with: "\n\u{2022} "),
            ingredients.isNotEmpty {
            ingredientsLabel.text = "\u{2022} \(ingredients)"
        } else {
            ingredientsText.isHidden = true
        }
    }

}
