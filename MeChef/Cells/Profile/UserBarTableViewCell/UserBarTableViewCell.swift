import UIKit

struct UserBarViewModel {
    let option: String
    let arrowHidden: Bool
    let hideBottomLine: Bool

    init(option: String,
         arrowHidden: Bool = false,
         hideBottomLine: Bool = false) {
        self.option = option
        self.arrowHidden = arrowHidden
        self.hideBottomLine = hideBottomLine
    }
}

final class UserBarTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var optionLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var bottomSpacerView: UIView!

    var viewModel: UserBarViewModel?

}

extension UserBarTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = UserBarViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: UserBarViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: UserBarViewModel) {
        self.viewModel = contentViewModel

        optionLabel.text = contentViewModel.option
        arrowImageView.isHidden = contentViewModel.arrowHidden
        bottomSpacerView.isHidden = contentViewModel.hideBottomLine
    }

}
