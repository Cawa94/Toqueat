import UIKit
import RxSwift
import Nuke

class ChefDeliverySlotsViewController: BaseStatefulController<Chef>,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var chefDeliverySlotsViewModel: ChefDeliverySlotsViewModel! {
        didSet {
            viewModel = chefDeliverySlotsViewModel
        }
    }

    private let disposeBag = DisposeBag()

    let margin: CGFloat = 10
    let cellsPerRow = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView,
            let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            else { return }

        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DeliverySlotCollectionViewCell")

    }

    override func viewWillLayoutSubviews() {
        guard let collectionView = collectionView,
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
            + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

}
