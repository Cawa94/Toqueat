import UIKit
import RxSwift
import Nuke

class OrdersViewController: BaseTableViewController<[BaseOrder], BaseOrder> {

    var ordersViewModel: OrdersViewModel! {
        didSet {
            tableViewModel = ordersViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "OrderTableViewCell")
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        title = "My Orders"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: ordersViewModel.isLoading)
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as OrderTableViewCell:
            orderCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as OrderTableViewCell:
            let order = ordersViewModel.elementAt(indexPath.row)
            let viewModel = OrderTableViewModel(order: order)
            orderCell.configureWith(contentViewModel: viewModel)
            orderCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushTrackOrderViewController(orderId: order.id)
                })
                .disposed(by: orderCell.disposeBag)
        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        ordersViewModel.elements = ordersViewModel.result.sorted(by: { $0.deliveryDate > $1.deliveryDate })
        super.onResultsState()
    }

}
