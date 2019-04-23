import UIKit
import RxSwift
import Nuke

class ChefOrdersViewController: BaseTableViewController<[Order], Order> {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    var chefOrdersViewModel: ChefOrdersViewModel! {
        didSet {
            tableViewModel = chefOrdersViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChefOrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefOrderTableViewCell")
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentChefProfileController(chefId: chefOrdersViewModel.chefId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefOrderTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: chefOrdersViewModel.isLoading)
        if indexPath.row == chefOrdersViewModel.elements.count - 1 {
            DispatchQueue.main.async {
                self.viewDidLayoutSubviews()
            }
        }
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as ChefOrderTableViewCell:
            orderCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let orderCell as ChefOrderTableViewCell:
            let order = chefOrdersViewModel.elementAt(indexPath.row)
            let viewModel = ChefOrderTableViewModel(order: order)
            orderCell.configureWith(contentViewModel: viewModel)
           /* orderCell.confirmOrderButton.rx.tap.subscribe(onNext: { _ in
                guard let chefLocation = SessionService.session?.chef?.stuartLocation
                    else { return }
                let createStuartSingle = self.chefOrdersViewModel.createStuartJobWith(orderId: viewModel.order.id,
                                                                                      chefLocation: chefLocation)
                self.hudOperationWithRetry(operationSingle: createStuartSingle,
                                           onSuccessClosure: { _ in
                                                self.chefOrdersViewModel.reload()
                                                self.presentAlertWith(title: "YEAH",
                                                                      message: "Order scheduled")
                                            },
                                           disposeBag: self.disposeBag)
                })
                .disposed(by: orderCell.disposeBag)
            orderCell.cancelOrderButton.rx.tap.subscribe(onNext: { _ in
                self.chefOrdersViewModel.changeOrderStatusWith(orderId: viewModel.order.id,
                                                               state: .canceled)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { _ in
                        self.presentAlertWith(title: "YEAH",
                                              message: "Order canceled")
                    })
                    .disposed(by: self.disposeBag)
                })
                .disposed(by: orderCell.disposeBag)*/
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
        chefOrdersViewModel.elements = chefOrdersViewModel.result.sorted(by: { $0.deliveryDate > $1.deliveryDate })
        super.onResultsState()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 60 // Orders title
    }

}
