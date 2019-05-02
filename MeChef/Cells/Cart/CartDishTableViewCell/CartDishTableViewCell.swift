import UIKit
import RxSwift
import Nuke
import SwipeCellKit

class CartDishTableViewCell: SwipeTableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!

    var disposeBag = DisposeBag()
    var hasControlsExpanded = false
    private var viewModel: CartDishTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        dishImageView.clipsToBounds = true
        dishImageView.roundCorners(radii: 5.0)
    }

}

extension CartDishTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = CartDishTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: CartDishTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: CartDishTableViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.dish.name
        let dishQuantity = contentViewModel.quantityInOrder ?? contentViewModel.dish.quantityInCart
        quantityLabel.text = dishQuantity > 1 ? "\(dishQuantity) dishes" : "\(dishQuantity) dish"
        let totalPrice = contentViewModel.dish.price.multiplying(by: NSDecimalNumber(value: dishQuantity))
        priceLabel.text = totalPrice.stringWithCurrency

        if let url = contentViewModel.dish.imageLink {
            Nuke.loadImage(with: url, into: dishImageView)
        } else {
            dishImageView.image = UIImage(named: "dish_placeholder")
        }
        dishImageView.contentMode = .scaleAspectFill
    }

}
