import UIKit
import RxSwift
import Nuke

class ChefOrderTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var dishesLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var cancelOrderButton: UIButton!

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

        orderIdLabel.text = "ID: \(contentViewModel.order.id)"
        userIdLabel.text = "USER ID: \(contentViewModel.order.user.id)"
        deliveryLabel.text = "DELIVERY \(contentViewModel.delivery)"
        dishesLabel.text = "DISHES COUNT: \(contentViewModel.order.dishes.count)"
        stateLabel.text = "\(contentViewModel.order.state)"
        stateLabel.textColor = contentViewModel.order.orderState == .scheduled
            ? .green : .red
    }

}
