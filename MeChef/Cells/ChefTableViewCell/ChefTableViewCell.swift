import UIKit
import RxSwift
import Nuke

class ChefTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipesNumberLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    var disposeBag = DisposeBag()
    private var viewModel: ChefTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        contentContainerView.roundCorners(radii: 15)
    }

}

extension ChefTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWithLoading(_ loading: Bool = false, contentViewModel: ChefTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefTableViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.chef.name
        recipesNumberLabel.text = "Ricette \(contentViewModel.chef.dishes?.count ?? 0)"
        if let url = contentViewModel.chef.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
            avatarImageView.contentMode = .scaleAspectFill
        }
    }

}
