import RxSwift

class CheckoutViewController: BaseStatefulController<Chef> {

    @IBOutlet weak var deliverySlotLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dishesPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var completeOrderButton: RoundedButton!

    var checkoutViewModel: CheckoutViewModel! {
        didSet {
            viewModel = checkoutViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var deliveryCost: NSDecimalNumber?

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = SessionService.session?.user?.address.fullAddress

        let completeOrderModel = RoundedButtonViewModel(title: "Complete Order", type: .squeezedOrange)
        completeOrderButton.configure(with: completeOrderModel)

        CartService.localCartDriver
            .drive(onNext: { cart in
                self.checkoutViewModel.getDeliveryCost(pickupAt: cart?.deliveryDate,
                                                       userAddress: self.addressLabel.text ?? "",
                                                       userComment: SessionService.session?.user?.apartment)
                    .asDriver(onErrorJustReturn: 0.00)
                    .drive(onNext: { deliveryCost in
                        self.deliveryCost = deliveryCost
                        let newTotal = (CartService.localCart?.total ?? 0.00).adding(deliveryCost)
                        self.deliveryPriceLabel.text = "€\(deliveryCost)"
                        self.totalPriceLabel.text = "€\(newTotal)"
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Checkout"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeCheckout))
    }

    @objc func closeCheckout() {
        NavigationService.popNavigationTopController()
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
            let deliverySlotId = CartService.localCart?.deliverySlotId,
            let deliveryDate = CartService.localCart?.deliveryDate,
            let dishes = CartService.localCart?.dishes,
            let chefId = CartService.localCart?.chef?.id,
            let deliveryAddress = addressLabel.text,
            let deliveryCost = deliveryCost
            else { return }
        let dishesPrice = dishes.map { ($0.price as Decimal) }.reduce(0, +)
        let deliveryComment = SessionService.session?.user?.apartment
        let orderParameters = OrderCreateParameters(userId: userId, dishIds: dishes.map { $0.id },
                                                    chefId: chefId, deliveryDate: deliveryDate,
                                                    deliverySlotId: deliverySlotId,
                                                    deliveryAddress: deliveryAddress,
                                                    deliveryComment: deliveryComment,
                                                    dishesPrice: NSDecimalNumber(decimal: dishesPrice),
                                                    deliveryPrice: deliveryCost)
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

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        dishesPriceLabel.text = "€\(CartService.localCart?.total ?? 0.00)"
        totalPriceLabel.text = "€\(CartService.localCart?.total ?? 0.00)"
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
