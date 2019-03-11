import UIKit
import RxSwift

class ChefTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipesNumberLabel: UILabel!

    var disposeBag = DisposeBag()
    private var viewModel: ChefTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}

extension ChefTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWithLoading(_ loading: Bool = false, contentViewModel: ChefTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefTableViewModel) {
        self.viewModel = contentViewModel

        nameLabel.text = contentViewModel.chef.name
        recipesNumberLabel.text = "Ricette \(contentViewModel.chef.dishes?.count ?? 0)"
    }

}
