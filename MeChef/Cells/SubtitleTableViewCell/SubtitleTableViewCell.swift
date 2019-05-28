import UIKit

class SubtitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    private var viewModel: SubtitleTableViewModel?

}

extension SubtitleTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = SubtitleTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: SubtitleTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: SubtitleTableViewModel) {
        self.viewModel = contentViewModel

        titleLabel.text = contentViewModel.title
        if let value = contentViewModel.value {
            valueLabel.text = value
        } else if let attributedValue = contentViewModel.attributedValue {
            valueLabel.attributedText = attributedValue
        }
    }

}
