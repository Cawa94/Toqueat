import RxSwift

class CheckoutViewController: BaseStatefulController<CheckoutViewModel.ResultType> {

    @IBOutlet weak var deliveryDateLabel: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let completeOrderModel = RoundedButtonViewModel(title: "Complete Order", type: .squeezedOrange)
        completeOrderButton.configure(with: completeOrderModel)
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Checkout"
    }

    // MARK: - Actions

    @IBAction func placeOrder(_ sender: Any) {
        guard let userId = SessionService.session?.user?.id,
            let deliverySlotId = CartService.localCart?.deliverySlotId,
            let deliveryDate = CartService.localCart?.deliveryDate,
            let dishes = CartService.localCart?.dishes,
            let chefId = CartService.localCart?.chef?.id,
            let deliveryAddress = addressLabel.text
            else { return }
        let dishesPrice = dishes.map { ($0.price as Decimal) }.reduce(0, +)
        let deliveryComment = SessionService.session?.user?.apartment
        let orderParameters = OrderCreateParameters(userId: userId, dishIds: dishes.map { $0.id },
                                                    chefId: chefId, deliveryDate: deliveryDate,
                                                    deliverySlotId: deliverySlotId,
                                                    deliveryAddress: deliveryAddress,
                                                    deliveryComment: deliveryComment,
                                                    dishesPrice: NSDecimalNumber(decimal: dishesPrice),
                                                    deliveryPrice: checkoutViewModel.result.deliveryCost)
        NetworkService.shared.createNewOrderWith(parameters: orderParameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { order in
                self.presentAlertWith(title: "YEAH", message: "Order placed with ID: \(order.id)",
                    actions: [ UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        NavigationService.dismissCartNavigationController()
                    })])
                CartService.localCart = .new
            })
            .disposed(by: disposeBag)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        deliveryDateLabel.attributedText = checkoutViewModel.cart.deliveryDate?.attributedCheckoutMessage
        addressLabel.text = SessionService.session?.user?.address.fullAddress
        let newTotal = (CartService.localCart?.total ?? 0.00).adding(checkoutViewModel.result.deliveryCost)
        deliveryPriceLabel.text = checkoutViewModel.result.deliveryCost.stringWithCurrency
        dishesPriceLabel.text = CartService.localCart?.total.stringWithCurrency
        totalPriceLabel.text = newTotal.stringWithCurrency
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
