import UIKit
import RxSwift

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UIGestureRecognizerDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var checkoutButton: RoundedButton!
    @IBOutlet private weak var totalLabel: UILabel!

    var cartViewModel: CartViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        let checkoutModel = RoundedButtonViewModel(title: "", type: .defaultOrange)
        checkoutButton.configure(with: checkoutModel)

        tableView.register(UINib(nibName: "CartDishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartDishTableViewCell")
        tableView.register(UINib(nibName: "CartHeaderView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "CartHeaderView")

        CartService.localCartDriver.drive(onNext: { localCart in
            self.cartViewModel.cart = localCart
            self.totalLabel.text = "€\(localCart?.total ?? 0.00)"
            self.tableView.reloadData()
        }).disposed(by: disposeBag)

    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentProfileController()
    }

    @IBAction func startCheckoutAction(_ sender: Any) {
        guard let cart = CartService.localCart, let chefId = cart.chef?.id
            else { return }
        NavigationService.pushCheckoutViewController(cart: cart, chefId: chefId)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "CartHeaderView") as? CartHeaderView,
            let chef = cartViewModel.chef
            else { return nil }
        headerCell.configure(chef: chef)
        headerCell.availabilityButton.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { _ in
                NavigationService.pushChefDeliverySlotsViewController(chefId: chef.id)
            })
            .disposed(by: headerCell.disposeBag)
        return headerCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.elements.count
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
            let dish = cartViewModel.elementAt(indexPath.row)
            dishCell.configureWith(contentViewModel: dish)
        default:
            break
        }
    }

}
