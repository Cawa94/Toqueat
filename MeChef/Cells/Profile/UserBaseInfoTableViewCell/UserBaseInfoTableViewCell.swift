import UIKit

struct UserBaseInfoCellViewModel {

    let baseUser: BaseUser
    let isChef: Bool

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
        iconImageView.image = UIImage(named: viewModel?.isChef ?? false ? "profile_chef_woman" : "profile")
    }

}
