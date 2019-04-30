import UIKit
import Nuke

struct UserBaseInfoCellViewModel {

    let baseUser: BaseUser
    let isChef: Bool
    let chefImageUrl: URL?

}

final class UserBaseInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    var viewModel: UserBaseInfoCellViewModel?

}

extension UserBaseInfoTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = UserBaseInfoCellViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: UserBaseInfoCellViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: UserBaseInfoCellViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = "\(contentViewModel.baseUser.name) \(contentViewModel.baseUser.lastname)"
        emailLabel.text = contentViewModel.baseUser.email
        if let url = contentViewModel.chefImageUrl {
            iconImageView.roundCorners(radii: self.iconImageView.frame.width/2,
                                       borderWidth: 1.0, borderColor: .lightGrayColor)
            Nuke.loadImage(with: url, into: iconImageView)
        } else {
            iconImageView.image = UIImage(named: viewModel?.isChef ?? false ? "chef_placeholder" : "profile")
        }
        iconImageView.contentMode = .scaleAspectFill
    }

}
