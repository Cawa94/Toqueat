import UIKit
import RxSwift
import Nuke

class ChefCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var recipesNumberLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    static let reuseID = "ChefCollectionViewCell"
    var disposeBag = DisposeBag()
    var cornerRadius: CGFloat = 0.0
    var avatarFrame: CGRect = .zero
    private var viewModel: ChefCollectionCellModel?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        avatarImageView.image = UIImage(named: "chef_placeholder")
    }

    override func awakeFromNib() {
        cornerRadius = self.avatarImageView.frame.width/2
        avatarImageView.roundCorners(radii: self.avatarImageView.frame.width/2,
                                     borderWidth: 2.0, borderColor: .mainOrangeColor)
        avatarFrame = avatarImageView.frame
    }

}

extension ChefCollectionViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefCollectionCellModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWithLoading(_ loading: Bool = false, contentViewModel: ChefCollectionCellModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefCollectionCellModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.chef.name
        lastnameLabel.text = contentViewModel.chef.lastname
        recipesNumberLabel.text = "Ricette \(contentViewModel.chef.dishes?.count ?? 0)"
        if let url = contentViewModel.chef.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.image = UIImage(named: "chef_placeholder")
        }
    }

}
