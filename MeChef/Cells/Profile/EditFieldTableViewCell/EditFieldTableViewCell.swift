import UIKit

final class EditFieldTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var bottomSpacerView: UIView!

    var viewModel: EditFieldTableViewModel?

}

extension EditFieldTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = EditFieldTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: EditFieldTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: EditFieldTableViewModel) {
        self.viewModel = contentViewModel

        textField.text = contentViewModel.fieldValue
        textField.placeholder = contentViewModel.placeholder
        textField.isSecureTextEntry = contentViewModel.secureText
        bottomSpacerView.isHidden = contentViewModel.hideBottomLine
    }

}
