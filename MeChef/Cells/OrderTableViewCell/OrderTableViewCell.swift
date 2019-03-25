import UIKit
import RxSwift
import Nuke

class OrderTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var dishesLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    var disposeBag = DisposeBag()
    private var viewModel: OrderTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        contentContainerView.roundCorners(radii: 15)
    }

}

extension OrderTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = OrderTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWithLoading(_ loading: Bool = false,
                              contentViewModel: OrderTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: OrderTableViewModel) {
        self.viewModel = contentViewModel

        orderIdLabel.text = "ID: \(contentViewModel.order.id)"
        totalLabel.text = "TOTAL: \(contentViewModel.order.totalPrice)"
        deliveryLabel.text = "DELIVERY \(contentViewModel.delivery)"
        dishesLabel.text = "DISHES COUNT: \(contentViewModel.order.dishes.count)"
        stateLabel.text = "\(contentViewModel.order.state)"
        stateLabel.textColor = contentViewModel.order.orderState == .scheduled
            ? .green : .red
    }

}
