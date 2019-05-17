import UIKit

final class EditDescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomSpacerView: UIView!

    private var viewModel: EditDescriptionTableViewModel?
    private var placeholderLabel: UILabel!

    public var hasContent: Bool {
        return placeholderLabel.isHidden
    }

    public var cellTextView: UITextView {
        return textView
    }

}

extension EditDescriptionTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = EditDescriptionTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: EditDescriptionTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: EditDescriptionTableViewModel) {
        self.viewModel = contentViewModel

        placeholderLabel = UILabel()
        placeholderLabel.text = viewModel?.placeholder
        placeholderLabel.font = UIFont.regularFontOf(size: 15.0)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .placeholderGrayApple
        placeholderLabel.isHidden = contentViewModel.fieldValue?.isNotEmpty ?? false

        textView.text = contentViewModel.fieldValue
        textView.textColor = .darkGrayColor
        bottomSpacerView.isHidden = contentViewModel.hideBottomLine
        textViewHeightConstraint.constant = textView.contentSize.height > 150
            ? textView.contentSize.height : 150
    }

}

extension EditDescriptionTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

}
