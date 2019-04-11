import UIKit
import RxSwift

final class DishDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addToBasketButton: RoundedButton!

    var viewModel: Dish?
    var disposeBag = DisposeBag()

    public var addToCartButton: UIButton {
        return addToBasketButton
    }

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let addToCartModel = RoundedButtonViewModel(title: "", type: .defaultOrange)
        addToBasketButton.configure(with: addToCartModel)
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
        priceLabel.text = "$\(contentViewModel.price)"
        ingredientsLabel.text = "\u{2022} Pasta\n\u{2022} Pomodoro\n\u{2022} Basilico"
    }

}
