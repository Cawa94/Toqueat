import UIKit
import RxSwift
import Nuke

class ChefOrdersViewController: BaseTableViewController<[Order], Order> {

    var chefOrdersViewModel: ChefOrdersViewModel! {
        didSet {
            tableViewModel = chefOrdersViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChefOrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefOrderTableViewCell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefOrderTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: chefOrdersViewModel.isLoading)
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
        case let orderCell as ChefOrderTableViewCell:
            orderCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as ChefOrderTableViewCell:
            let order = chefOrdersViewModel.elementAt(indexPath.row)
            let viewModel = ChefOrderTableViewModel(order: order)
            orderCell.configureWithLoading( contentViewModel: viewModel)
        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefOrdersViewModel.elements = chefOrdersViewModel.result
        super.onResultsState()
    }

}
