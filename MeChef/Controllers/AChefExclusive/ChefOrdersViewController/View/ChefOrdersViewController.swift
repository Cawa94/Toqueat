import UIKit
import RxSwift
import Nuke

class ChefOrdersViewController: BaseStatefulController<ChefOrdersViewModel.ResultType>,
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

    var chefOrdersViewModel: ChefOrdersViewModel! {
        didSet {
            viewModel = chefOrdersViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentChefProfileController(chefId: chefOrdersViewModel.chefId)
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 17 // hours ranges
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 // weekdays
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeliverySlotCollectionViewCell.reuseID,
                                                            for: indexPath) as? DeliverySlotCollectionViewCell else {
                                                                return UICollectionViewCell()
        }

        cell.titleLabel.text = chefOrdersViewModel.elementTitleAt(indexPath)
        if indexPath.section != 0 {
            let isAvailable = chefOrdersViewModel.isLoading
                ? false : chefOrdersViewModel.isAvailableAt(indexPath)
            cell.titleLabel.font = isAvailable ? .mediumFontOf(size: 14) : .regularFontOf(size: 14)
            cell.backgroundColor = chefOrdersViewModel.cellColorForHours
            cell.titleLabel.textColor = chefOrdersViewModel.textColorForAvailability(isAvailable)
            cell.drawBorders(isWeekday: false)
        } else {
            cell.titleLabel.font = .boldFontOf(size: 16)
            cell.backgroundColor = chefOrdersViewModel.cellColorForWeekdays
            cell.titleLabel.textColor = chefOrdersViewModel.textColorForWeekdays
            cell.drawBorders(isWeekday: true)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefOrdersViewModel.chefSlots = chefOrdersViewModel.result.deliverySlots
        self.collectionView.reloadData()
    }

}

/* orderCell.confirmOrderButton.rx.tap.subscribe(onNext: { _ in
 guard let chefLocation = SessionService.session?.chef?.stuartLocation
 else { return }
 let createStuartSingle = self.chefOrdersViewModel.createStuartJobWith(orderId: viewModel.order.id,
 chefLocation: chefLocation)
 self.hudOperationWithRetry(operationSingle: createStuartSingle,
 onSuccessClosure: { _ in
 self.chefOrdersViewModel.reload()
 self.presentAlertWith(title: "YEAH",
 message: "Order scheduled")
 },
 disposeBag: self.disposeBag)
 })
 .disposed(by: orderCell.disposeBag)
 orderCell.cancelOrderButton.rx.tap.subscribe(onNext: { _ in
 self.chefOrdersViewModel.changeOrderStatusWith(orderId: viewModel.order.id,
 state: .canceled)
 .observeOn(MainScheduler.instance)
 .subscribe(onSuccess: { _ in
 self.presentAlertWith(title: "YEAH",
 message: "Order canceled")
 })
 .disposed(by: self.disposeBag)
 })
 .disposed(by: orderCell.disposeBag)*/
