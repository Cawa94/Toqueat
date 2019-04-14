import UIKit
import RxSwift
import RxGesture

class ChefsViewController: BaseStatefulController<[Chef]>,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBarContainerView: UIView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var chefsViewModel: ChefsViewModel! {
        didSet {
            viewModel = chefsViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var selectedIndex: IndexPath?
    private lazy var searchBar: UISearchBar = .toqueatSearchBar

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.frame = searchBarContainerView.bounds
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

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentProfileController()
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
            chefCell.configureWith(loading: true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefCollectionViewCell:
            let chef = chefsViewModel.elementAt(indexPath.row)
            chefCell.configureWith(contentViewModel: chef)
            chefCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    self.selectedIndex = indexPath
                    let chefController = NavigationService.chefViewController(chefId: chef.id)
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

        return CGSize(width: width, height: ChefsViewModel.Constants.cellHeight)
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
            self.collectionView.reloadData {
                self.viewDidLayoutSubviews()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        contentViewHeightConstraint.constant = collectionViewHeightConstraint.constant
            + 60 // Chefs title
            + 56 // searchBar
        self.view.layoutIfNeeded()
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// swiftlint:disable all
extension UICollectionView {

    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in
            completion()
        }
    }

}
