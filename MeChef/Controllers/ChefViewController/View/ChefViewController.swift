import UIKit
import RxSwift

class ChefViewController: BaseTableViewController<Chef, Dish> {

    @IBOutlet weak var chefNameLabel: UILabel!

    var chefViewModel: ChefViewModel! {
        didSet {
            tableViewModel = chefViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = chefViewModel.elementAt(indexPath.row)
            dishCell.configureWith(dish)
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        chefNameLabel.text = chefViewModel.chefName
        super.onLoadingState()
    }

    override func onResultsState() {
        chefViewModel.elements = chefViewModel.result?.dishes ?? []
        chefNameLabel.text = chefViewModel.chefName
        super.onResultsState()
    }

}
