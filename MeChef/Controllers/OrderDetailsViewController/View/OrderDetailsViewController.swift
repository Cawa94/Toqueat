import UIKit
import RxSwift
import RxCocoa
import Nuke
import SwiftDate
import Pulley

class OrderDetailsViewController: UIViewController {

    @IBOutlet private weak var driverDeliveringView: DriverDeliveringView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var orderLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dishesPriceLabel: UILabel!
    @IBOutlet private weak var deliveryPriceLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var cancelOrderButton: RoundedButton!
    @IBOutlet private weak var mainScrollView: UIScrollView!

    var scrollView: UIScrollView {
        return mainScrollView
    }

    var callDriverButton: UIButton {
        return driverDeliveringView.callDriverButton
    }

    var viewModel: OrderDetailsViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CartDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartDishTableViewCell")
        tableView.register(UINib(nibName: "SubtitleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SubtitleTableViewCell")
    }

    @IBAction func cancelOrderAction(_ sender: Any) {
        guard let orderId = viewModel.order?.id, let stuartId = viewModel.stuartJob?.id
            else { return }
        let networkService = NetworkService.shared
        let cancelOrderSingle = networkService.cancelStuartJobWith(stuartId)
            .flatMap { _ in
                networkService.changeOrderStatusWith(orderId: orderId,
                                                     state: .canceled)
            }
        self.hudOperationWithSingle(operationSingle: cancelOrderSingle,
                                    onSuccessClosure: { _ in
                                        self.presentAlertWith(title: .commonSuccess(),
                                                              message: .orderDetailsCanceled())
                                        NavigationService.reloadChefWeekplan = true
                                    },
                                    disposeBag: self.disposeBag)
    }

    override func viewDidLayoutSubviews() {
        let cancelButtonHeight: CGFloat = SessionService.isChef ? 160 : 0
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + orderLabelTopConstraint.constant
            + 200 // view height without table
            + cancelButtonHeight
    }

    // fake result state, called when PulleyController has result
    func onResultState() {

        if viewModel.deliveryInProgress {
            driverDeliveringView.isHidden = false
            orderLabelTopConstraint.constant = driverDeliveringView.bounds.height + 30
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            let driverModel = DriverDeliveringViewModel(stuartJob: viewModel.stuartJob,
                                                        isChef: SessionService.isChef)
            driverDeliveringView.configure(with: driverModel)
            updateEtaText()
        }

        // order can be canceled if is chef OR TO DEVELOP!!! -> is customer and missing 12+ hours to delivery
        if SessionService.isChef
            && (viewModel.order?.orderState == .waitingForConfirmation || viewModel.order?.orderState == .scheduled) {
            let cancelModel = RoundedButtonViewModel(title: .commonCancel(), type: .squeezedRed)
            cancelOrderButton.configure(with: cancelModel)
            cancelOrderButton.isHidden = false
        } /*else if let deliveryDate = viewModel.order?.deliveryDate,
            !SessionService.isChef, (Date() + 2.hours) < (deliveryDate - 12.hours),
            (viewModel.order?.orderState == .waitingForConfirmation || viewModel.order?.orderState == .scheduled) {
            let cancelModel = RoundedButtonViewModel(title: .commonCancel(), type: .squeezedRed)
            cancelOrderButton.configure(with: cancelModel)
            cancelOrderButton.isHidden = false
        }*/ else {
            cancelOrderButton.isHidden = true
        }

        dishesPriceLabel.text = viewModel.order?.dishesPrice.stringWithCurrency
        deliveryPriceLabel.text = viewModel.order?.deliveryPrice.stringWithCurrency
        totalPriceLabel.text = viewModel.order?.totalPrice.stringWithCurrency

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateEtaText() {
        driverDeliveringView.updateEtaText()
    }

}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 5
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.numberOfItems(for: 0)
        default:
            return SessionService.isChef ? 2 : 3
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 70
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String
        switch indexPath.section {
        case 0:
            cellIdentifier = "CartDishTableViewCell"
        default:
            cellIdentifier = "SubtitleTableViewCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: viewModel.isLoading)
        return cell
    }

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as CartDishTableViewCell:
            dishCell.configureWith(loading: true)
        case let subtitleCell as SubtitleTableViewCell:
            subtitleCell.configureWith(loading: true)
        default:
            break
        }
    }

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as CartDishTableViewCell:
            let dish = viewModel.elements[indexPath.row]
            let dishViewModel = CartDishTableViewModel(
                dish: dish,
                quantityInOrder: viewModel.quantityOf(dish: dish),
                isInCart: false)
            dishCell.configureWith(contentViewModel: dishViewModel)
            if indexPath.row == viewModel.elements.count - 1 {
                DispatchQueue.main.async {
                    self.viewDidLayoutSubviews()
                }
            }
        case let subtitleCell as SubtitleTableViewCell:
            guard let order = viewModel.order
                else { return }
            let cellModel: SubtitleTableViewModel
            switch indexPath.row {
            case 0:
                cellModel = SubtitleTableViewModel(title: .orderDetailsOrderNumber(),
                                                   value: "\(order.id)")
            case 1:
                cellModel = SubtitleTableViewModel(title: .commonDeliveryDate(),
                                                   attributedValue: order.deliveryDate.attributedCheckoutMessage)
            case 2:
                cellModel = SubtitleTableViewModel(title: .orderDetailsDeliveryTo(),
                                                   value: "\(order.deliveryAddress)")
            default:
                cellModel = SubtitleTableViewModel(title: "")
            }
            subtitleCell.configureWith(contentViewModel: cellModel)
        default:
            break
        }
    }

}
