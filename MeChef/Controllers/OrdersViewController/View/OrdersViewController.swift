import UIKit
import RxSwift
import Nuke

class OrdersViewController: BaseTableViewController<[BaseOrder], OrdersViewModel.OrdersSection> {

    @IBOutlet private weak var emptyOrdersLabel: UILabel!

    var ordersViewModel: OrdersViewModel! {
        didSet {
            tableViewModel = ordersViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: OrderStateTableHeaderView.reuseIdentifier, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: OrderStateTableHeaderView.reuseIdentifier)
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "OrderTableViewCell")
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        title = .profileMyOrders()
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
            let order = ordersViewModel.elementAt(indexPath.section).orders[indexPath.row]
            let viewModel = OrderTableViewModel(order: order)
            orderCell.configureWith(contentViewModel: viewModel)
            orderCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushOrderPulleyViewController(orderId: order.id,
                                                                    stuartId: order.stuartId)
                })
                .disposed(by: orderCell.disposeBag)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: OrderStateTableHeaderView.reuseIdentifier) as? OrderStateTableHeaderView
            else { return nil }
        headerView.configureWith(state: ordersViewModel.isLoading
            ? "" : ordersViewModel.elements[section].state.localizedDescription)
        return headerView
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersViewModel.isLoading ? 2 : ordersViewModel.elements[section].orders.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ordersViewModel.elements.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        ordersViewModel.elements = ordersViewModel.ordersGroupedByState
        if ordersViewModel.elements.isEmpty {
            self.tableView.isHidden = true
            emptyOrdersLabel.text = SessionService.isChef
                ? .ordersEmptyChefPlaceholder() : .ordersEmptyPlaceholder()
        }

        super.onResultsState()
    }

}
