import UIKit
import RxSwift
import Nuke

class ChefDishTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var editButton: UIButton!

    public var edit: UIButton {
        return editButton
    }

    var disposeBag = DisposeBag()
    private var viewModel: ChefDish?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        dishImageView.clipsToBounds = true
        dishImageView.roundCorners(radii: 5.0)
    }

}

extension ChefDishTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefDish
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: ChefDish? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefDish) {
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
