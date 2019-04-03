import UIKit
import RxSwift
import RxGesture

class ChefsViewController: BaseStatefulController<[Chef]>,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UIViewControllerTransitioningDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarContainerView: UIView!

    var chefsViewModel: ChefsViewModel! {
        didSet {
            viewModel = chefsViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var selectedIndex: IndexPath?
    private let animationController = AnimationController()
    private lazy var searchBar: UISearchBar = .toqueatSearchBar

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarContainerView.addSubview(searchBar)
        searchBar.placeholder = "Search chef"
        searchBar.delegate = self
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .skip(1)
            .drive(onNext: { _ in
                debugPrint("START SEARCHING...")
            })
            .disposed(by: disposeBag)

        let nib = UINib(nibName: ChefCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: ChefCollectionViewCell.reuseID)
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return chefsViewModel.numberOfItems(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefCollectionViewCell",
                                                      for: indexPath)
        configure(cell, at: indexPath, isLoading: chefsViewModel.isLoading)
        return cell
    }

    private func configure(_ cell: UICollectionViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    private func configureWithPlaceholders(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefCollectionViewCell:
            chefCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefCollectionViewCell:
            let chef = chefsViewModel.elementAt(indexPath.row)
            let viewModel = ChefCollectionCellModel(chef: chef)
            chefCell.configureWithLoading(contentViewModel: viewModel)
            chefCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    self.selectedIndex = indexPath
                    self.animationController.originCornerRadius = chefCell.cornerRadius
                    let chefController = NavigationService.chefViewController(chefId: chef.id)
                    chefController.transitioningDelegate = self
                    NavigationService.pushChefViewController(chefController)
                })
                .disposed(by: chefCell.disposeBag)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = collectionView.bounds.width / CGFloat(ChefsViewModel.Constants.numberOfColumns)
            - ChefsViewModel.Constants.sectionInsets.left
        let width = columnWidth - (ChefsViewModel.Constants.horizontalSpacingBetweenCells
            / CGFloat(ChefsViewModel.Constants.numberOfColumns))

        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return ChefsViewModel.Constants.sectionInsets
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func onResultsState() {
        chefsViewModel.elements = chefsViewModel.result
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
            /*guard let selectedIndex = selectedIndex,
                let selectedCell = collectionView.cellForItem(at: selectedIndex) as? ChefCollectionViewCell
                else { return nil }
            animationController.originFrame = CGRect(x: selectedCell.frame.origin.x + selectedCell.avatarFrame.origin.x,
                                                     y: selectedCell.frame.origin.y + selectedCell.avatarFrame.origin.y,
                                                     width: selectedCell.avatarFrame.size.width,
                                                     height: selectedCell.avatarFrame.size.height)
            animationController.presenting = true
            return animationController*/
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
        /*
        animationController.presenting = false
        return animationController
         */
    }

}
