import UIKit
import RxSwift
import Nuke

class OrdersViewController: BaseTableViewController<[Order], Order> {

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: ordersViewModel.isLoading)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    private func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as OrderTableViewCell:
            orderCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as OrderTableViewCell:
            let order = ordersViewModel.elementAt(indexPath.row)
            let viewModel = OrderTableViewModel(order: order)
            orderCell.configureWithLoading(contentViewModel: viewModel)
            orderCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushTrackOrderViewController(orderId: order.id,
                                                                   stuartId: order.stuartId)
                })
                .disposed(by: orderCell.disposeBag)
        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        ordersViewModel.elements = ordersViewModel.result
        super.onResultsState()
    }

}
