import RxSwift

class CheckoutViewController: BaseStatefulController<Order> {

    @IBOutlet weak var deliverySlotLabel: UILabel!

    var checkoutViewModel: CheckoutViewModel! {
        didSet {
            viewModel = checkoutViewModel
        }
    }

    private let disposeBag = DisposeBag()

    @IBAction func selectDeliverySlotAction(_ sender: Any) {
        guard let chefId = checkoutViewModel.result.chef?.id
            else { return }
        let deliverySlotsController = NavigationService.deliverySlotsViewController(chefId: chefId)
        deliverySlotsController.deliverySlotDriver
            .map { $0.deliveryTime }
            .drive(self.deliverySlotLabel.rx.text)
            .disposed(by: disposeBag)
        NavigationService.presentDeliverySlots(controller: deliverySlotsController)
    }

}
