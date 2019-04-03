import UIKit
import RxSwift

class DishesViewController: BaseTableViewController<[Dish], Dish>,
    UISearchBarDelegate {

    @IBOutlet weak var searchBarContainerView: UIView!

    var dishesViewModel: DishesViewModel! {
        didSet {
            tableViewModel = dishesViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private lazy var searchBar: UISearchBar = .toqueatSearchBar

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarContainerView.addSubview(searchBar)
        searchBar.placeholder = "Search dishes"
        searchBar.delegate = self
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .skip(1)
            .drive(onNext: { _ in
                debugPrint("START SEARCHING...")
            })
            .disposed(by: disposeBag)

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
    }

    // MARK: - UITableViewDelegate

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
                                               chef: dish.chef)
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        dishesViewModel.elements = dishesViewModel.result
        super.onResultsState()
    }

}
