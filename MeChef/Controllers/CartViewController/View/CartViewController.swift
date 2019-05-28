import UIKit
import RxSwift
import SwipeCellKit

private extension CGFloat {

    static let swipeActionWidth: CGFloat = 57

}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UIGestureRecognizerDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkoutButton: RoundedButton!
    @IBOutlet private weak var totalLabel: UILabel!

    var cartViewModel: CartViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let checkoutModel = RoundedButtonViewModel(title: "Choose delivery time", type: .defaultOrange)
        checkoutButton.configure(with: checkoutModel)

        tableView.register(UINib(nibName: "CartDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartDishTableViewCell")
        tableView.register(UINib(nibName: "CartHeaderView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "CartHeaderView")

        CartService.localCartDriver.drive(onNext: { localCart in
            self.cartViewModel.cart = localCart
            self.totalLabel
                .text = "Total: \(localCart?.total.stringWithCurrency ?? NSDecimalNumber(value: 0).stringWithCurrency)"
            self.tableView.isHidden = !self.cartViewModel.hasContent
            self.tableView.reloadData()
            self.checkoutButton.isHidden = !self.cartViewModel.hasContent
            self.totalLabel.isHidden = !self.cartViewModel.hasContent
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentProfileController()
    }

    @IBAction func selectDeliveryTimeAction(_ sender: Any) {
        guard let cart = CartService.localCart, let chefId = cart.chef?.id
            else { return }
        NavigationService.pushDeliverySlotsViewController(chefId: chefId)
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height >= 400 ? 400 : tableView.contentSize.height
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "CartHeaderView") as? CartHeaderView,
            let chef = cartViewModel.chef
            else { return nil }
        headerCell.configure(chef: chef)
        return headerCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.elements.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
            let dish = cartViewModel.elementAt(indexPath.row)
            let dishViewModel = CartDishTableViewModel(dish: dish,
                                                       quantityInOrder: nil)
            dishCell.configureWith(contentViewModel: dishViewModel)
            dishCell.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
                dishCell.showSwipe(orientation: .right)
            }).disposed(by: dishCell.disposeBag)
            dishCell.delegate = self
            if indexPath.row == cartViewModel.elements.count - 1 {
                DispatchQueue.main.async {
                    self.viewDidLayoutSubviews()
                }
            }
        default:
            break
        }
    }

}

extension CartViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard let dishCell = tableView.cellForRow(at: indexPath)
            as? CartDishTableViewCell else { return nil }

        guard orientation == .right
            else {
                if dishCell.hasControlsExpanded {
                    dishCell.hasControlsExpanded = false
                    dishCell.showSwipe(orientation: .left)
                }
                return nil
        }

        dishCell.hasControlsExpanded = !dishCell.hasControlsExpanded
        if !dishCell.hasControlsExpanded {
            dishCell.showSwipe(orientation: .left)
            return nil
        }

        let dish = self.cartViewModel.elementAt(indexPath.row)
        let addOneAction = SwipeAction(style: .default,
                                       title: "+") { base, _ in
                                        if dish.canAddToCart() {
                                            CartService.addToCart(dish)
                                        }
                                        self.checkColor(swipeAction: base,
                                                        tableView: tableView,
                                                        localCartDish: dish,
                                                        indexPath: indexPath)
        }
        addOneAction.backgroundColor = dish.canAddToCart() ? .mainOrangeColor : .lightGrayColor
        addOneAction.font = .boldFontOf(size: 35)
        addOneAction.textColor = .white

        let removeOneAction = SwipeAction(style: .destructive,
                                          title: "-") { base, _ in
                                            CartService.removeFromCart(dish)
                                            self.checkColor(swipeAction: base,
                                                            tableView: tableView,
                                                            localCartDish: dish,
                                                            indexPath: indexPath)
        }
        removeOneAction.backgroundColor = .highlightedOrangeColor
        removeOneAction.font = .boldFontOf(size: 35)
        removeOneAction.textColor = .white

        return [addOneAction, removeOneAction]
    }

    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.maximumButtonWidth = .swipeActionWidth
        options.minimumButtonWidth = .swipeActionWidth
        return options
    }

    func checkColor(swipeAction: SwipeAction,
                    tableView: UITableView,
                    localCartDish: LocalCartDish,
                    indexPath: IndexPath) {
        swipeAction.backgroundColor = localCartDish.canAddToCart() ? .mainOrangeColor : .lightGrayColor
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
            if let cell = tableView.cellForRow(at: indexPath) as? CartDishTableViewCell {
                cell.showSwipe(orientation: .right)
            }
        }
    }

}
