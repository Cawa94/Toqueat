import RxSwift
import Stripe

class CheckoutViewController: BaseStatefulController<CheckoutViewModel.ResultType> {

    // Parameters
    let fakePayment = false // 3€ Total (2€ dishes | 1€ delivery)

    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dishesPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var choosePaymentMethodButton: UIButton!
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var completeOrderButton: RoundedButton!

    var checkoutViewModel: CheckoutViewModel! {
        didSet {
            viewModel = checkoutViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let completeOrderModel = RoundedButtonViewModel(title: .checkoutCompleteOrder(), type: .squeezedOrange)
        completeOrderButton.configure(with: completeOrderModel)

        guard let paymentContext = checkoutViewModel.paymentContext
            else { return }

        paymentContext.delegate = self
        paymentContext.paymentCurrency = "EUR"
        paymentContext.hostViewController = self
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = .checkoutTitle()
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
        let deliveryComment = SessionService.session?.user?.stuartComment
        let orderParameters = OrderCreateParameters(
            userId: userId, dishIds: dishes.map { $0.id },
            chefId: chefId, deliveryDate: deliveryDate,
            deliverySlotId: deliverySlotId,
            deliveryAddress: deliveryAddress,
            deliveryComment: deliveryComment,
            dishesPrice: fakePayment ? 2.00 : NSDecimalNumber(decimal: dishesPrice),
            deliveryPrice: fakePayment ? 1.00 : checkoutViewModel.result.deliveryCost,
            paymentIntentId: "")
        checkoutViewModel.orderParameters = orderParameters

        checkoutViewModel.paymentContext?.requestPayment()
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        deliveryDateLabel.attributedText = checkoutViewModel.cart.deliveryDate?.attributedCheckoutMessage
        addressLabel.text = SessionService.session?.user?.fullAddress
        let newTotal = (CartService.localCart?.total ?? 0.00).adding(checkoutViewModel.result.deliveryCost)
        deliveryPriceLabel.text = checkoutViewModel.result.deliveryCost.stringWithCurrency
        dishesPriceLabel.text = CartService.localCart?.total.stringWithCurrency
        totalPriceLabel.text = newTotal.stringWithCurrency
        checkoutViewModel.paymentContext?.paymentAmount = fakePayment
            ? 300 : Int(truncating: newTotal.multiplying(byPowerOf10: 2))

        super.onResultsState()
    }

}

extension CheckoutViewController: STPPaymentContextDelegate {

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        self.presentAlertWith(title: String.commonWarning().capitalized,
                              message: error.localizedDescription)
    }

    // Called when user select a payment method
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //self.activityIndicator.animating = paymentContext.loading
        completeOrderButton.isHidden = paymentContext.selectedPaymentMethod == nil
        paymentMethodImageView.isHidden = paymentContext.selectedPaymentMethod == nil
        paymentMethodLabel.text = paymentContext.selectedPaymentMethod?.label
        paymentMethodImageView.image = paymentContext.selectedPaymentMethod?.image
    }

    // swiftlint:disable all
    // Called when user press the 'complete order' button
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didCreatePaymentResult paymentResult: STPPaymentResult,
                        completion: @escaping STPErrorBlock) {
        guard let orderParameters = checkoutViewModel.orderParameters
            else { return }
        self.startLoading(with: self.loadingStateView)

        NetworkService.shared.generatePaymentIntent(parameters:
            StripePaymentIntentParameters(amount: paymentContext.paymentAmount,
                                          paymentMethod: paymentResult.source.stripeID,
                                          chefId: orderParameters.chefId,
                                          dishesPrice: Int(truncating: orderParameters
                                            .dishesPrice.multiplying(byPowerOf10: 2)),
                                          deliveryPrice: Int(truncating: orderParameters
                                            .deliveryPrice.multiplying(byPowerOf10: 2))))
            .map { intentResponse in
                self.checkoutViewModel.paymentIntentId = intentResponse.id
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: intentResponse.clientSecret)
                paymentIntentParams.sourceId = paymentResult.source.stripeID
                paymentIntentParams.returnURL = "toqueat://stripe-redirect"
                let client = STPAPIClient.shared()
                client.confirmPaymentIntent(with: paymentIntentParams, completion: { (paymentIntent, error) in
                    if let error = error {
                        completion(error)
                    } else if let paymentIntent = paymentIntent {
                        switch paymentIntent.status {
                        case .succeeded: // ---- PAYMENT SUCCEDED ----
                            completion(nil)
                        case .requiresSourceAction: // ---- REQUIRE EXTRA STEP TO AUTHORIZE PAYMENT ----
                            guard let redirectContext = STPRedirectContext(
                                paymentIntent: paymentIntent,
                                completion: { clientSecret, redirectError in
                                    if let redirectError = redirectError {
                                        completion(redirectError)
                                    } else {
                                        // Fetch the latest status of the Payment Intent if necessary
                                        STPAPIClient.shared()
                                            .retrievePaymentIntent(withClientSecret: clientSecret) { paymentIntent, error in
                                                if let error = error {
                                                    completion(error)
                                                } else if let paymentIntent = paymentIntent {
                                                    switch paymentIntent.status {
                                                    case .succeeded: // ---- PAYMENT SUCCEDED ----
                                                        debugPrint("PLACE ORDER")
                                                        completion(nil)
                                                    default:
                                                        self.endLoading(with: self.loadingStateView)
                                                        self.presentAlertWith(title: String.commonWarning().capitalized, message: .errorPayment())
                                                    }
                                                }
                                        }
                                    }
                            }) else {
                                debugPrint("PaymentIntent action is not yet supported by the SDK")
                                // This PaymentIntent action is not yet supported by the SDK.
                                return
                            }
                            // Note you must retain this for the duration of the redirect flow
                            // It dismisses any presented view controller upon deallocation.
                            self.checkoutViewModel.redirectContext = redirectContext

                            // opens SFSafariViewController to the necessary URL
                            redirectContext.startRedirectFlow(from: self)
                        default:
                            self.endLoading(with: self.loadingStateView)
                            self.presentAlertWith(title: String.commonWarning().capitalized, message: .errorPayment())
                        }
                    }
                })
            }.subscribe().disposed(by: self.disposeBag)

    }

    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFinishWith status: STPPaymentStatus,
                        error: Error?) {
        switch status {
        case .success:
            placeOrder()
        case .error:
            self.endLoading(with: self.loadingStateView)
            self.presentAlertWith(title: String.commonWarning().capitalized,
                                  message: error?.localizedDescription ?? .errorPayment())
        case .userCancellation:
            self.endLoading(with: self.loadingStateView)
            return
        }
    }

    func placeOrder() {
        guard let orderParameters = checkoutViewModel.orderParameters,
            let paymentIntentId = checkoutViewModel.paymentIntentId
            else { return }
        NetworkService.shared
            .createNewOrderWith(parameters: orderParameters.copyWith(intentId: paymentIntentId))
            .flatMap {
                self.checkoutViewModel.createStuartJobWith(orderId: $0.id)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.endLoading(with: self.loadingStateView)
                self.presentAlertWith(title: .commonSuccess(), message: .checkoutCompleted(),
                                      actions: [ UIAlertAction(title: .commonOk(), style: .default, handler: { _ in
                                        NavigationService.dismissCartNavigationController()
                                      })])
                CartService.localCart = .new
            }, onError: { _ in
                self.endLoading(with: self.loadingStateView)
            })
            .disposed(by: self.disposeBag)
    }

}

extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        debugPrint("Finished")
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        debugPrint("Authorized")
    }

}
