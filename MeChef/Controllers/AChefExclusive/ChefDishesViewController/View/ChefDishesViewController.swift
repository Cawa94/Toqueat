import UIKit
import RxSwift
import Nuke

class ChefDishesViewController: BaseTableViewController<Chef, ChefDish> {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    var chefDishesViewModel: ChefDishesViewModel! {
        didSet {
            tableViewModel = chefDishesViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChefDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefDishTableViewCell")
        tableView.register(UINib(nibName: "AddDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "AddDishTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NavigationService.reloadChefDishes {
            chefDishesViewModel.reload()
            NavigationService.reloadChefDishes = false
        }
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentChefProfileController(chefId: chefDishesViewModel.chefId)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefDishesViewModel.numberOfItems(for: section) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row < (chefDishesViewModel.numberOfItems(for: indexPath.section)) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ChefDishTableViewCell",
                                                 for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddDishTableViewCell",
                                                 for: indexPath)
        }
        configure(cell, at: indexPath, isLoading: chefDishesViewModel.isLoading)
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            dishCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as ChefDishTableViewCell:
            let dish = chefDishesViewModel.elementAt(indexPath.row)
            dishCell.configureWith(contentViewModel: dish)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushChefDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
            dishCell.edit.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
        case let addDishCell as AddDishTableViewCell:
            addDishCell.addDish.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushChefDishViewController(dishId: nil)
                })
                .disposed(by: addDishCell.disposeBag)
            DispatchQueue.main.async {
                self.viewDidLayoutSubviews()
            }
        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefDishesViewModel.elements = chefDishesViewModel.result.dishes ?? []
        super.onResultsState()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 60 // Dishes title
    }

}
