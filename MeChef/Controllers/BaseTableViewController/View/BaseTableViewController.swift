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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.numberOfItems(for: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.tableView.reloadData()
    }

    override func onLoadingState() {
        self.tableView.reloadData()
    }

    override func onEmptyState() {
        self.tableView.reloadData()
    }

}
