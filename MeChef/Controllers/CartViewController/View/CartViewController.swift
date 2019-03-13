import UIKit
import RxSwift

class CartViewController: BaseTableViewController<Order, Dish> {

    var cartViewModel: CartViewModel! {
        didSet {
            tableViewModel = cartViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
    }

    @IBAction func startCheckoutAction(_ sender: Any) {
        guard let userId = SessionService.session?.user?.id
            else { return }
        NavigationService.pushCheckoutViewController(userId: userId)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: cartViewModel.isLoading)
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
            let dish = cartViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish,
                                               chefName: dish.chef?.name)
            dishCell.configureWithLoading( contentViewModel: viewModel)
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
        cartViewModel.elements = cartViewModel.result.dishes ?? []
        super.onResultsState()
    }

}
