import UIKit
import RxSwift
import Nuke

class ChefDeliverySlotsViewController: BaseStatefulController<[DeliverySlot]>,
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

    var chefDeliverySlotsViewModel: ChefDeliverySlotsViewModel! {
        didSet {
            viewModel = chefDeliverySlotsViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 15 // hours ranges
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

        cell.titleLabel.text = chefDeliverySlotsViewModel.elementAt(indexPath)
        cell.titleLabel.font = indexPath.section == 0
            ? cell.titleLabel.font.withSize(20) : cell.titleLabel.font.withSize(15)
        if indexPath.section != 0 {
            cell.backgroundColor = chefDeliverySlotsViewModel.isLoading
                ? .white
                : chefDeliverySlotsViewModel.colorForAvailability(chefDeliverySlotsViewModel.isAvailableAt(indexPath))
        } else {
            cell.backgroundColor = .groupTableViewBackground
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.collectionView.reloadData()
    }

}
