import UIKit

final class UserBarTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var optionLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var checkedImageView: UIImageView!
    @IBOutlet private weak var bottomSpacerView: UIView!

    var viewModel: UserBarTableViewModel?

}

extension UserBarTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = UserBarTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: UserBarTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: UserBarTableViewModel) {
        self.viewModel = contentViewModel

        optionLabel.text = contentViewModel.option
        arrowImageView.isHidden = contentViewModel.arrowHidden
        bottomSpacerView.isHidden = contentViewModel.hideBottomLine
        checkedImageView.isHidden = contentViewModel.checkHidden
    }

}
