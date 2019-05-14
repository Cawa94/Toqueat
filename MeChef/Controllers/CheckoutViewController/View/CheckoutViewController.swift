import RxSwift
import Stripe

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

        guard let paymentContext = checkoutViewModel.paymentContext
            else { return }

        paymentContext.delegate = self
        paymentContext.hostViewController = self
        paymentContext.paymentAmount = 5000 // This is in cents, i.e. $50 USD
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Checkout"
    }

    // MARK: - Actions

    @IBAction func choosePaymentButtonTapped() {
        checkoutViewModel.paymentContext?.presentPaymentMethodsViewController()
    }

    @IBAction func completeOrderAction(_ sender: Any) {
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
        checkoutViewModel.orderParameters = orderParameters

        checkoutViewModel.paymentContext?.requestPayment()
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

extension CheckoutViewController: STPPaymentContextDelegate {

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        self.presentAlertWith(title: "WARNING", message: error.localizedDescription)
    }

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        /*
        self.activityIndicator.animating = paymentContext.loading
        self.paymentButton.enabled = paymentContext.selectedPaymentOption != nil
        self.paymentLabel.text = paymentContext.selectedPaymentOption?.label
        self.paymentIcon.image = paymentContext.selectedPaymentOption?.image
        */
    }

    func paymentContext(_ paymentContext: STPPaymentContext,
                        didCreatePaymentResult paymentResult: STPPaymentResult,
                        completion: @escaping STPErrorBlock) {
        let payAndCreateOrderSingle = NetworkService.shared.generatePaymentIntent(parameters:
            StripePaymentIntentParameters(amount: paymentContext.paymentAmount,
                                          paymentMethod: paymentResult.source.stripeID))
            .map { clientSecret in
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.sourceId = paymentResult.source.stripeID
                paymentIntentParams.returnURL = "toqueat://stripe-redirect"
                let client = STPAPIClient.shared()
                client.confirmPaymentIntent(with: paymentIntentParams, completion: { (paymentIntent, error) in
                    if let error = error {
                        self.presentAlertWith(title: "WARNING", message: error.localizedDescription)
                    } else if let paymentIntent = paymentIntent {
                        self.checkPaymentStatus(paymentIntent)
                    }
                })
            }

        self.hudOperationWithSingle(operationSingle: payAndCreateOrderSingle,
                                    onSuccessClosure: { _ in },
                                    disposeBag: self.disposeBag)

    }

    func checkPaymentStatus(_ paymentIntent: STPPaymentIntent) {
        switch paymentIntent.status {
        case .succeeded: // ---- PAYMENT SUCCEDED ----
            placeOrder()
        case .requiresSourceAction: // ---- REQUIRE EXTRA STEP TO AUTHORIZE PAYMENT ----
            redirectPayment(paymentIntent: paymentIntent)
        case .requiresSource:
            debugPrint("requiresSource")
        default:
            break
        }
    }

    func placeOrder() {
        guard let orderParameters = checkoutViewModel.orderParameters
            else { return }
        NetworkService.shared.createNewOrderWith(parameters: orderParameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { order in
                self.presentAlertWith(title: "YEAH", message: "Order placed with ID: \(order.id)",
                    actions: [ UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        NavigationService.dismissCartNavigationController()
                    })])
                CartService.localCart = .new
            })
            .disposed(by: self.disposeBag)
    }

    func redirectPayment(paymentIntent: STPPaymentIntent) {
        guard let redirectContext = STPRedirectContext(
            paymentIntent: paymentIntent,
            completion: { clientSecret, redirectError in
                if let redirectError = redirectError {
                    self.presentAlertWith(title: "WARNING", message: redirectError.localizedDescription)
                } else {
                    // Fetch the latest status of the Payment Intent if necessary
                    STPAPIClient.shared()
                        .retrievePaymentIntent(withClientSecret: clientSecret) { paymentIntent, error in
                        if let error = error {
                            self.presentAlertWith(title: "WARNING", message: error.localizedDescription)
                        } else if let paymentIntent = paymentIntent {
                            self.checkPaymentStatus(paymentIntent)
                        }
                    }
                }
        }) else {
            // This PaymentIntent action is not yet supported by the SDK.
            return
        }
        // Note you must retain this for the duration of the redirect flow
        // It dismisses any presented view controller upon deallocation.
        checkoutViewModel.redirectContext = redirectContext

        // opens SFSafariViewController to the necessary URL
        redirectContext.startRedirectFlow(from: self)
    }

    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFinishWith status: STPPaymentStatus,
                        error: Error?) {
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
