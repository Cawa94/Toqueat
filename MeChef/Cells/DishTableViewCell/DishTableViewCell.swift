import UIKit
import RxSwift
import Nuke

class DishTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var chefLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!

    var disposeBag = DisposeBag()
    private var viewModel: DishTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        contentContainerView.roundCorners(radii: 15)
    }

}

extension DishTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = DishTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWithLoading(_ loading: Bool = false, contentViewModel: DishTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: DishTableViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.dish.name
        chefLabel.isHidden = contentViewModel.chefName == nil
        chefLabel.text = "Chef: \(contentViewModel.chefName ?? "Unknown")"
        priceLabel.text = "\(contentViewModel.dish.price) Euros"
        if let url = contentViewModel.dish.imageLink {
            Nuke.loadImage(with: url, into: dishImageView)
            dishImageView.contentMode = .scaleAspectFill
        }
    }

}
