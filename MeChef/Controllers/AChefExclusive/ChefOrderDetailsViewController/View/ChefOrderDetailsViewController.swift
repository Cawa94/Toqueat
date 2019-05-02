import UIKit
import RxSwift
import RxCocoa

class ChefOrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var confirmOrderButton: RoundedButton!
    @IBOutlet private weak var refuseOrderButton: RoundedButton!

    var viewModel: ChefOrderDetailsViewModel!

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

    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .mainOrangeColor
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGrayColor]
        navigationController?.isNavigationBarHidden = false
        title = "Order Details"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain, target: nil, action: nil)
    }

    @IBAction func confirmOrderAction(_ sender: Any) {
        guard let chefLocation = SessionService.session?.chef?.stuartLocation
            else { return }
        let createStuartSingle = viewModel.createStuartJobWith(orderId: viewModel.order.id,
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
        viewModel.changeOrderStatusWith(orderId: viewModel.order.id,
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.elements.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        configureWithContent(cell, at: indexPath)
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as CartDishTableViewCell:
            let dish = viewModel.elementAt(indexPath.row)
            let dishViewModel = CartDishTableViewModel(dish: dish,
                                                       quantityInOrder: viewModel.quantityOf(dish: dish))
            dishCell.configureWith(contentViewModel: dishViewModel)
            if indexPath.row == viewModel.elements.count - 1 {
                DispatchQueue.main.async {
                    self.viewDidLayoutSubviews()
                }
            }
        default:
            break
        }
    }

}
