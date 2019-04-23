import UIKit
import Nuke
import RxSwift

final class ChefBaseInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    var viewModel: BaseChef?
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        avatarImageView.roundCorners(radii: self.avatarImageView.frame.width/2,
                                     borderWidth: 2.0, borderColor: .mainOrangeColor)
    }

}

extension ChefBaseInfoTableViewCell: PlaceholderConfigurable {

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

        let formattedChefString = NSMutableAttributedString()
        formattedChefString
            .normal("Prepared by ", size: 16.0)
            .bold("\(contentViewModel.name)", size: 16.0)
        nameLabel.attributedText = formattedChefString
        if let url = contentViewModel.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
        } else {
            avatarImageView.image = UIImage(named: "chef_placeholder")
        }
        avatarImageView.contentMode = .scaleAspectFill
    }

}
