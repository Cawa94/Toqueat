import UIKit
import RxSwift
import Nuke

class ChefWeekplanViewController: BaseStatefulController<ChefWeekplanViewModel.ResultType>,
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

    var chefWeekplanViewModel: ChefWeekplanViewModel! {
        didSet {
            viewModel = chefWeekplanViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NavigationService.reloadChefWeekplan {
            chefWeekplanViewModel.reload()
            NavigationService.reloadChefWeekplan = false
        }
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentChefProfileController(chefId: chefWeekplanViewModel.chefId)
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

        cell.titleLabel.text = chefWeekplanViewModel.elementTitleAt(indexPath)
        if indexPath.section != 0 {
            if let order = chefWeekplanViewModel.orderAt(indexPath) {
                cell.titleLabel.font = .boldFontOf(size: 14)
                cell.backgroundColor = chefWeekplanViewModel.cellColorForOrder(state: order.orderState)
                cell.titleLabel.textColor = chefWeekplanViewModel.textColorForOrderCell(state: order.orderState)
            } else {
                let isAvailable = chefWeekplanViewModel.isLoading
                    ? false : chefWeekplanViewModel.isAvailableAt(indexPath)
                cell.titleLabel.font = isAvailable ? .mediumFontOf(size: 14) : .regularFontOf(size: 14)
                cell.backgroundColor = chefWeekplanViewModel.cellColorForHours
                cell.titleLabel.textColor = chefWeekplanViewModel.textColorForAvailability(isAvailable)
            }
            cell.drawBorders(isWeekday: false)
        } else {
            cell.titleLabel.font = .boldFontOf(size: 16)
            cell.backgroundColor = chefWeekplanViewModel.cellColorForWeekdays
            cell.titleLabel.textColor = chefWeekplanViewModel.textColorForWeekdays
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
        if let order = chefWeekplanViewModel.orderAt(indexPath) {
            NavigationService.pushOrderPulleyViewController(orderId: order.id, stuartId: order.stuartId)
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefWeekplanViewModel.chefSlots = chefWeekplanViewModel.result.deliverySlots
        self.collectionView.reloadData()

        super.onResultsState()
    }

}
