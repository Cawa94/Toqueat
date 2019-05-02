import UIKit
import RxSwift
import Nuke

class ChefDeliverySlotsViewController: BaseStatefulController<[DeliverySlot]>,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var availableColorView: UIView!
    @IBOutlet private weak var unavailableColorView: UIView!
    @IBOutlet private weak var instructionsLabel: UILabel!

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

        instructionsLabel.text = chefDeliverySlotsViewModel.editable
        ? "Here you can let people know when you're availble to deliver. Tap a slot to enable/disable it"
        : "The chef will be available to deliver dishes only during this hours"
        availableColorView.roundCorners(radii: availableColorView.bounds.height/2)
        unavailableColorView.roundCorners(radii: unavailableColorView.bounds.height/2)

        let nib = UINib(nibName: DeliverySlotCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DeliverySlotCollectionViewCell.reuseID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = !chefDeliverySlotsViewModel.editable
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Chef Availability"
        if chefDeliverySlotsViewModel.editable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(saveAndClose))
        }
    }

    @objc func saveAndClose() {
        let newDeliverySlots = chefDeliverySlotsViewModel.activeSlots.map { $0.id }
        let updateSingle = NetworkService.shared.updateDeliverySlotsFor(chefId: chefDeliverySlotsViewModel.chefId,
                                                                        slots: newDeliverySlots)

        self.hudOperationWithSingle(operationSingle: updateSingle,
                                    onSuccessClosure: { _ in
                                        self.chefDeliverySlotsViewModel.reload()
                                        NavigationService.reloadChefOrders = true
                                        self.presentAlertWith(title: "YEAH",
                                                              message: "Slots updated")
                                    },
                                   disposeBag: self.disposeBag)
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

        cell.titleLabel.text = chefDeliverySlotsViewModel.elementTitleAt(indexPath)
        if indexPath.section != 0 {
            let isAvailable = chefDeliverySlotsViewModel.isLoading
                ? false : chefDeliverySlotsViewModel.isAvailableAt(indexPath)
            cell.titleLabel.font = isAvailable ? .mediumFontOf(size: 14) : .regularFontOf(size: 14)
            cell.backgroundColor = chefDeliverySlotsViewModel.cellColorForAvailability(isAvailable)
            cell.titleLabel.textColor = chefDeliverySlotsViewModel.textColorForAvailability(isAvailable)
            cell.drawBorders(isWeekday: false)
        } else {
            cell.titleLabel.font = .boldFontOf(size: 16)
            cell.backgroundColor = chefDeliverySlotsViewModel.cellColorForWeekdays
            cell.titleLabel.textColor = chefDeliverySlotsViewModel.textColorForWeekdays
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
        if chefDeliverySlotsViewModel.editable {
            let slot = chefDeliverySlotsViewModel.elementAt(indexPath)
            chefDeliverySlotsViewModel.toggle(slot: slot)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefDeliverySlotsViewModel.activeSlots = chefDeliverySlotsViewModel.result
        self.collectionView.reloadData()
    }

}
