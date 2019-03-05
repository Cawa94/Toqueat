import UIKit
import RxSwift

class DishesViewController: BaseTableViewController<[Dish], Dish> {

    var dishesViewModel: DishesViewModel! {
        didSet {
            tableViewModel = dishesViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

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
            let dish = dishesViewModel.elementAt(indexPath.row)
            dishCell.configureWith(dish)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        dishesViewModel.elements = dishesViewModel.result ?? []
        super.onResultsState()
    }

}
