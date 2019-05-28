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
    @IBOutlet private weak var refuseOrderButton: RoundedButton!

    var viewModel: OrderDetailsViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelModel = RoundedButtonViewModel(title: "Refuse", type: .squeezedWhite)
        refuseOrderButton.configure(with: cancelModel)

        tableView.register(UINib(nibName: "CartDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartDishTableViewCell")
        tableView.register(UINib(nibName: "SubtitleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SubtitleTableViewCell")
    }

    @IBAction func cancelOrderAction(_ sender: Any) {
        /*viewModel.changeOrderStatusWith(orderId: viewModel.order?.id,
                                        state: .canceled)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.presentAlertWith(title: "YEAH",
                                      message: "Order canceled")
                NavigationService.reloadChefOrders = true
            })
            .disposed(by: self.disposeBag)*/
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + orderLabelTopConstraint.constant
            + 200 // view height without table
    }

    // fake result state, called when PulleyController has result
    func onResultState() {

        if viewModel.deliveryInProgress {
            driverDeliveringView.isHidden = false
            orderLabelTopConstraint.constant = 180
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            let driverModel = DriverDeliveringViewModel(stuartJob: viewModel.stuartJob,
                                                        driverPhone: viewModel.driverPhone,
                                                        isChef: SessionService.isChef)
            driverDeliveringView.configure(with: driverModel)
            updateEtaText()
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
            return 3
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
                quantityInOrder: viewModel.quantityOf(dish: dish))
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
                cellModel = SubtitleTableViewModel(title: "Order Number",
                                                   value: "\(order.id)")
            case 1:
                cellModel = SubtitleTableViewModel(title: "Delivery date",
                                                   attributedValue: order.deliveryDate.attributedCheckoutMessage)
            case 2:
                cellModel = SubtitleTableViewModel(title: "Delivery to",
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
