import RxSwift

class CheckoutViewController: BaseTableViewController<Chef, LocalCartDish> {

    @IBOutlet weak var deliverySlotLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!

    var checkoutViewModel: CheckoutViewModel! {
        didSet {
            tableViewModel = checkoutViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = SessionService.session?.user?.address.fullAddress

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
        CartService.localCartDriver
            .drive(onNext: { cart in
                self.checkoutViewModel.getDeliveryCost(pickupAt: cart?.deliveryDate,
                                                       userAddress: self.addressLabel.text ?? "",
                                                       userComment: SessionService.session?.user?.apartment)
                    .asDriver(onErrorJustReturn: "0.00 EUR")
                    .drive(self.deliveryPriceLabel.rx.text)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @IBAction func selectDeliverySlotAction(_ sender: Any) {
        let deliverySlotsController = NavigationService
            .deliverySlotsViewController(chefId: checkoutViewModel.chefId)
        deliverySlotsController.deliverySlotDriver
            .drive(self.deliverySlotLabel.rx.text)
            .disposed(by: disposeBag)
        NavigationService.presentDeliverySlots(controller: deliverySlotsController)
    }

    @IBAction func placeOrder(_ sender: Any) {
        guard let userId = SessionService.session?.user?.id,
            let deliveryDate = CartService.localCart?.deliveryDate,
            let dishes = CartService.localCart?.dishes,
            let chefId = CartService.localCart?.chefId,
            let deliveryAddress = addressLabel.text
            else { return }
        let dishesPrice = dishes.map { ($0.price as Decimal) }.reduce(0, +)
        let deliveryComment = SessionService.session?.user?.apartment
        let orderParameters = OrderCreateParameters(userId: userId, dishIds: dishes.map { $0.id },
                                                    chefId: chefId, deliveryDate: deliveryDate,
                                                    deliveryAddress: deliveryAddress,
                                                    deliveryComment: deliveryComment,
                                                    dishesPrice: NSDecimalNumber(decimal: dishesPrice),
                                                    deliveryPrice: NSDecimalNumber(string: deliveryPriceLabel.text))
        NetworkService.shared.createNewOrderWith(parameters: orderParameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { order in
                self.presentAlertWith(title: "YEAH", message: "Order placed with ID: \(order.id)",
                    actions: [ UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        NavigationService.dismissCartNavigationController()
                    })])
                CartService.localCart = .new
            }, onError: { _ in })
            .disposed(by: disposeBag)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutViewModel.elements.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        configureWithContent(cell, at: indexPath)
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = checkoutViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish.asDish,
                                               chefName: nil)
            dishCell.configureWithLoading( contentViewModel: viewModel)
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        checkoutViewModel.elements = checkoutViewModel.cart.dishes ?? []
        super.onResultsState()
    }

}

private extension String {

    var fullAddress: String {
        guard let city = SessionService.session?.user?.city.name,
            let zipcode = SessionService.session?.user?.zipcode
            else { return self }
        return "\(self), \(zipcode) \(city)"
    }

}
