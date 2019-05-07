import UIKit
import RxSwift
import RxCocoa

class ChefOrderDetailsViewController: BaseTableViewController<Order, LocalCartDish> {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var confirmOrderButton: RoundedButton!
    @IBOutlet private weak var refuseOrderButton: RoundedButton!

    var chefOrderDetailsViewModel: ChefOrderDetailsViewModel! {
        didSet {
            tableViewModel = chefOrderDetailsViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        let confirmModel = RoundedButtonViewModel(title: "Accept", type: .squeezedOrange)
        confirmOrderButton.configure(with: confirmModel)
        let cancelModel = RoundedButtonViewModel(title: "Refuse", type: .squeezedWhite)
        refuseOrderButton.configure(with: cancelModel)

        tableView.register(UINib(nibName: "CartDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartDishTableViewCell")
    }

    override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Order Details"
    }

    @IBAction func confirmOrderAction(_ sender: Any) {
        guard let chefLocation = SessionService.session?.chef?.stuartLocation
            else { return }
        let createStuartSingle = chefOrderDetailsViewModel
            .createStuartJobWith(orderId: chefOrderDetailsViewModel.result.id,
                                 chefLocation: chefLocation)
        self.hudOperationWithSingle(operationSingle: createStuartSingle,
                                    onSuccessClosure: { _ in
                                        self.presentAlertWith(title: "YEAH",
                                                              message: "Order scheduled")
                                        NavigationService.reloadChefOrders = true
        },
                                   disposeBag: self.disposeBag)
    }

    @IBAction func cancelOrderAction(_ sender: Any) {
        chefOrderDetailsViewModel.changeOrderStatusWith(orderId: chefOrderDetailsViewModel.result.id,
                                                        state: .canceled)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.presentAlertWith(title: "YEAH",
                                      message: "Order canceled")
                NavigationService.reloadChefOrders = true
            })
            .disposed(by: self.disposeBag)
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 150 // view height without table
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefOrderDetailsViewModel.elements.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: chefOrderDetailsViewModel.isLoading)
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as CartDishTableViewCell:
            dishCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as CartDishTableViewCell:
            let dish = chefOrderDetailsViewModel.elementAt(indexPath.row)
            let dishViewModel = CartDishTableViewModel(
                dish: dish,
                quantityInOrder: chefOrderDetailsViewModel.quantityOf(dish: dish))
            dishCell.configureWith(contentViewModel: dishViewModel)
            if indexPath.row == chefOrderDetailsViewModel.elements.count - 1 {
                DispatchQueue.main.async {
                    self.viewDidLayoutSubviews()
                }
            }
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefOrderDetailsViewModel.elements =
            chefOrderDetailsViewModel.result.dishes.map { $0.asLocalCartDish }.uniqueElements
        super.onResultsState()
    }

}
