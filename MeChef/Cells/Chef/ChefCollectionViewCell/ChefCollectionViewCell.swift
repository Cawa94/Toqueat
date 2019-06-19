import UIKit
import RxSwift
import Nuke

class ChefCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instaUsernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    static let reuseID = "ChefCollectionViewCell"
    var disposeBag = DisposeBag()
    private var viewModel: BaseChef?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        avatarImageView.image = UIImage(named: "chef_placeholder")
    }

    override func awakeFromNib() {
        avatarImageView.roundCorners(radii: self.avatarImageView.frame.width/2,
                                     borderWidth: 2.0, borderColor: .mainOrangeColor)
    }

}

extension ChefCollectionViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = BaseChef
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: BaseChef? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: BaseChef) {
        self.viewModel = contentViewModel

        nameLabel.text = "\(contentViewModel.name) \(contentViewModel.lastname)"
        instaUsernameLabel.isHidden = contentViewModel.instagramUsername?.isEmpty ?? true
        instaUsernameLabel.text = "@\(contentViewModel.instagramUsername ?? "")"
        if let url = contentViewModel.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.image = UIImage(named: "chef_placeholder")
        }
    }

}
