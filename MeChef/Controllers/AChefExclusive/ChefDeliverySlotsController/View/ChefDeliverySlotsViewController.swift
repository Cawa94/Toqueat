import UIKit
import RxSwift
import Nuke

class ChefDeliverySlotsViewController: BaseStatefulController<[DeliverySlot]>,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var availableColorView: UIView!
    @IBOutlet private weak var unavailableColorView: UIView!

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

        availableColorView.roundCorners(radii: availableColorView.bounds.height/2)
        availableColorView.backgroundColor = .highlightedOrangeColor
        unavailableColorView.roundCorners(radii: unavailableColorView.bounds.height/2,
                                          borderWidth: 1, borderColor: .mainGrayColor)

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Chef Availability"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(closeAvailability))
    }

    @objc func closeAvailability() {
        NavigationService.popNavigationTopController()
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
        if indexPath.section != 0 {
            let isAvailable = chefDeliverySlotsViewModel.isLoading
                ? false : chefDeliverySlotsViewModel.isAvailableAt(indexPath)
            cell.titleLabel.font = isAvailable ? .mediumFontOf(size: 14) : .regularFontOf(size: 14)
            cell.backgroundColor = chefDeliverySlotsViewModel.cellColorForAvailability(isAvailable)
            cell.titleLabel.textColor = chefDeliverySlotsViewModel.textColorForAvailability(isAvailable)
        } else {
            cell.backgroundColor = .groupTableViewBackground
            cell.titleLabel.font = .mediumFontOf(size: 16)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.collectionView.reloadData()
    }

}
