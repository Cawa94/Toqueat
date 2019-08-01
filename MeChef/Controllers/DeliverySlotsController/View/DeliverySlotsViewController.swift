import RxSwift
import RxCocoa
import RxOptional

private extension CGFloat {

    static let bottomPadding: CGFloat = 10

}

class DeliverySlotsViewController: BaseStatefulController<DeliverySlotsViewModel.ResultType>,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.bounces = false
        }
    }

    @IBOutlet weak var gridLayout: StickyGridCollectionViewLayout! {
        didSet {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 0
        }
    }

    @IBOutlet private weak var availableColorView: UIView!
    @IBOutlet private weak var unavailableColorView: UIView!
    @IBOutlet private weak var busyColorView: UIView!
    @IBOutlet private weak var goToPaymentView: GoToPaymentView!
    @IBOutlet private weak var goToPaymentBottomConstraint: NSLayoutConstraint!

    var deliverySlotsViewModel: DeliverySlotsViewModel! {
        didSet {
            viewModel = deliverySlotsViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        availableColorView.roundCorners(radii: availableColorView.bounds.height/2)
        unavailableColorView.roundCorners(radii: unavailableColorView.bounds.height/2)
        busyColorView.roundCorners(radii: availableColorView.bounds.height/2)

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)

        goToPaymentView.openCheckoutButton.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { _ in
                guard let localCart = CartService.localCart
                    else { return }
                NavigationService.pushCheckoutViewController(cart: localCart,
                                                             chefId: self.deliverySlotsViewModel.chefId)
            })
            .disposed(by: disposeBag)
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = .commonDeliveryDate()
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DeliverySlot.hoursTable.count // hours ranges
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DeliverySlot.weekdayTable.count // weekdays
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeliverySlotCollectionViewCell.reuseID,
                                                            for: indexPath) as? DeliverySlotCollectionViewCell else {
                                                                return UICollectionViewCell()
        }

        cell.titleLabel.text = deliverySlotsViewModel.elementTitleAt(indexPath)
        if indexPath.section != 0 {
            let isAvailable = deliverySlotsViewModel.isLoading
                ? false : deliverySlotsViewModel.isAvailableAt(indexPath)
            cell.titleLabel.font = isAvailable ? .mediumFontOf(size: 14) : .regularFontOf(size: 14)
            let deliverySlot = deliverySlotsViewModel.deliverySlotAt(indexPath)
            var isSelected = false
            var hasOrder = false
            if let selectedSlot = deliverySlotsViewModel.selectedSlot, deliverySlot == selectedSlot {
                isSelected = true
            } else if deliverySlotsViewModel.hasAnOrderWith(slotId: deliverySlot.id, at: indexPath) {
                hasOrder = true
            }
            cell.backgroundColor = deliverySlotsViewModel.cellColorForHours(isSelected: isSelected,
                                                                            hasOrder: hasOrder)
            cell.titleLabel.textColor = deliverySlotsViewModel.textColorForAvailability(isAvailable,
                                                                                        isSelected: isSelected,
                                                                                        hasOrder: hasOrder)
            cell.drawBorders(isWeekday: false)
        } else {
            cell.titleLabel.font = .boldFontOf(size: 16)
            cell.backgroundColor = deliverySlotsViewModel.cellColorForWeekdays
            cell.titleLabel.textColor = deliverySlotsViewModel.textColorForWeekdays
            cell.drawBorders(isWeekday: true)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 { // weekdays
            return CGSize(width: 120, height: 50)
        }
        return CGSize(width: 120, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deliverySlot = deliverySlotsViewModel.deliverySlotAt(indexPath)
        if deliverySlotsViewModel.isAvailableAt(indexPath),
            !deliverySlotsViewModel.hasAnOrderWith(slotId: deliverySlot.id, at: indexPath) {
            let deliveryDate = deliverySlotsViewModel
                .deliveryDate(weekdayId: deliverySlot.weekdayId, hourId: deliverySlot.hourId)
            CartService.localCart = CartService.localCart?.copyWith(deliveryDate: deliveryDate,
                                                                    deliverySlotId: deliverySlot.id)
            deliverySlotsViewModel.selectedSlot = deliverySlot
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            showToast(for: deliverySlot, date: deliveryDate)
        }
    }

    func showToast(for deliverySlot: DeliverySlot, date: Date) {
        goToPaymentView.configure(with: GoToPaymentViewModel(selectedSlot: deliverySlot, date: date))

        UIView.animate(withDuration: 0.25) {
            self.goToPaymentBottomConstraint.constant = .bottomPadding
            self.view.layoutIfNeeded()

            self.collectionView.contentInset.bottom = self.goToPaymentView.frame.height
                + .bottomPadding + .bottomPadding
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.collectionView.reloadData()

        super.onResultsState()
    }

}
