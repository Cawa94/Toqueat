import UIKit
import RxSwift
import Nuke

class DishTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var chefImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!

    var disposeBag = DisposeBag()
    private var viewModel: DishTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        dishImageView.clipsToBounds = true
        /*contentContainerViewOutlet.roundCorners(radii: 0,
                                                borderWidth: 0.5,
                                                borderColor: .lightGray)*/
        chefImageView.roundCorners(radii: 17.5, borderWidth: 2.0, borderColor: .white)
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
        priceLabel.text = "$\(contentViewModel.dish.price)"
        if let url = contentViewModel.dish.imageLink {
            Nuke.loadImage(with: url, into: dishImageView)
            dishImageView.contentMode = .scaleAspectFill
        }
        if let chefUrl = contentViewModel.chef?.avatarLink {
            Nuke.loadImage(with: chefUrl, into: chefImageView)
            chefImageView.contentMode = .scaleAspectFill
        } else {
            chefImageView.isHidden = true
        }
    }

}
