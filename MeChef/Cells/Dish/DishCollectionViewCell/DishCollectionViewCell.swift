import UIKit
import RxSwift
import Nuke

class DishCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!

    static let reuseID = "DishCollectionViewCell"
    var disposeBag = DisposeBag()
    private var viewModel: Dish?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        dishImageView.image = UIImage(named: "dish_placeholder")
    }

    override func awakeFromNib() {
        dishImageView.clipsToBounds = true
        contentContainerViewOutlet.roundCorners(radii: 15.0)
    }

}

extension DishCollectionViewCell: PlaceholderConfigurable {

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
        priceLabel.text = contentViewModel.price.stringWithCurrency
        if let url = contentViewModel.imageLink {
            Nuke.loadImage(with: url, into: dishImageView)
        } else {
            dishImageView.image = UIImage(named: "dish_placeholder")
        }
        dishImageView.contentMode = .scaleAspectFill
    }

}
