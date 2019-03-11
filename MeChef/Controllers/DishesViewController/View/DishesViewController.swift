import UIKit
import RxSwift

class DishesViewController: BaseTableViewController<[Dish], Dish> {

    var dishesViewModel: DishesViewModel! {
        didSet {
            tableViewModel = dishesViewModel
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
        configure(cell, at: indexPath, isLoading: dishesViewModel.isLoading)
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
        case let dishCell as DishTableViewCell:
            dishCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = dishesViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish,
                                               chefName: dish.chef?.name)
            dishCell.configureWithLoading( contentViewModel: viewModel)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
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
        dishesViewModel.elements = dishesViewModel.result
        super.onResultsState()
    }

}
