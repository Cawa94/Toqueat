import UIKit

final class UserBaseInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!

    var viewModel: BaseUser?

}

extension UserBaseInfoTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = BaseUser
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: BaseUser? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: BaseUser) {
        self.viewModel = contentViewModel

        nameLabel.text = "\(contentViewModel.name) \(contentViewModel.lastname)"
        emailLabel.text = contentViewModel.email
    }

}
