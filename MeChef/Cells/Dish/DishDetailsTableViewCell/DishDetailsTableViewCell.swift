import UIKit
import RxSwift

final class DishDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var categoryServingsLabel: UILabel!
    @IBOutlet private weak var ingredientsText: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var addToCartView: AddToCartView!

    var viewModel: Dish?
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

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}

extension DishDetailsTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = Dish
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: Dish? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: Dish) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.name
        descriptionLabel.text = contentViewModel.description
        let addButtonModel = AddToCartViewModel(dish: contentViewModel)
        addToCartView.configureWith(addButtonModel)
        categoryServingsLabel.text = "\(contentViewModel.categories?.first?.name ?? "") "
            + "- \(contentViewModel.servings ?? 1) \(String.dishServings())"
        if let ingredients = contentViewModel.ingredients?.replacingOccurrences(of: ",",
                                                                                with: "\n\u{2022} "),
            ingredients.isNotEmpty {
            ingredientsLabel.text = "\u{2022} \(ingredients)"
        } else {
            ingredientsText.isHidden = true
        }
    }

}
