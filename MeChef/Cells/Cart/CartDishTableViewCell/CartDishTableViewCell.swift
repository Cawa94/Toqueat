import UIKit
import RxSwift
import Nuke

class CartDishTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!

    var disposeBag = DisposeBag()
    private var viewModel: LocalCartDish?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        dishImageView.clipsToBounds = true
        dishImageView.roundCorners(radii: 5.0)
    }

}

extension CartDishTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = LocalCartDish
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: LocalCartDish? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: LocalCartDish) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.name
        priceLabel.text = "€\(contentViewModel.price)"
        if let url = contentViewModel.imageLink {
            Nuke.loadImage(with: url, into: dishImageView)
            dishImageView.contentMode = .scaleAspectFill
        }
    }

}
