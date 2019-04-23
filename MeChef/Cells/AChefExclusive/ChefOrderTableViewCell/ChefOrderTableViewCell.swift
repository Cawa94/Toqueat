import UIKit
import RxSwift
import Nuke

class ChefOrderTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var dishesLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    var disposeBag = DisposeBag()
    private var viewModel: ChefOrderTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        contentContainerView.roundCorners(radii: 15)
    }

}

extension ChefOrderTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefOrderTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: ChefOrderTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefOrderTableViewModel) {
        self.viewModel = contentViewModel

        deliveryLabel.text = "\(contentViewModel.delivery)"
        dishesLabel.text = "\(contentViewModel.order.dishes.count) dishes"
        stateLabel.text = "\(contentViewModel.order.state.capitalized)"
        switch contentViewModel.order.orderState {
        case .waitingForConfirmation:
            stateLabel.textColor = .red
        case .scheduled, .enRoute:
            stateLabel.textColor = .mainOrangeColor
        case .delivered:
            stateLabel.textColor = .green
        case .canceled:
            stateLabel.textColor = .darkGrayColor
        }
    }

}
