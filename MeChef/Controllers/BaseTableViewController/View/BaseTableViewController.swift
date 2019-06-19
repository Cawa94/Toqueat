import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

class BaseTableViewController<ResultType, ElementType>: BaseStatefulController<ResultType>,
    UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        super.viewDidLoad()
    }

    var tableViewModel: BaseTableViewModel<ResultType, ElementType>! {
        didSet {
            viewModel = tableViewModel
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.numberOfItems(for: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {}

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {}

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.tableView.reloadData()
        super.onResultsState()
    }

    override func onLoadingState() {
        super.onLoadingState()
        self.tableView.reloadData()
    }

    override func onEmptyState() {
        super.onEmptyState()
        self.tableView.reloadData()
    }

}
