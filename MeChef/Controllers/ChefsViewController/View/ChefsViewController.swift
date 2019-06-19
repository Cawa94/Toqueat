import UIKit
import RxSwift
import RxGesture
import Nuke

class ChefsViewController: BaseStatefulController<[BaseChef]>,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBarContainerView: UIView!
    @IBOutlet private weak var searchBarHeightConstraint: NSLayoutConstraint!

    var chefsViewModel: ChefsViewModel! {
        didSet {
            viewModel = chefsViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var selectedIndex: IndexPath?
    private lazy var searchBar: UISearchBar = .toqueatSearchBar

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.scrollView.delegate = self

        searchBar.frame = searchBarContainerView.bounds
        searchBarContainerView.addSubview(searchBar)
        searchBar.placeholder = .mainSearchChef()
        searchBar.delegate = self
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .skip(1)
            .debounce(0.5)
            .drive(onNext: { text in
                NetworkService.shared.searchChef(query: text.isNotEmpty ? text : nil)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { filteredChefs in
                        self.chefsViewModel.elements = filteredChefs
                        self.collectionView.reloadData {
                            self.viewDidLayoutSubviews()
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        let nib = UINib(nibName: ChefCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: ChefCollectionViewCell.reuseID)

        configureNuke()
    }

    func configureNuke() {
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFill,
            failure: .scaleAspectFill,
            placeholder: .scaleAspectFit)

        ImageLoadingOptions.shared.contentModes = contentModes
        ImageLoadingOptions.shared.placeholder = UIImage()
        ImageLoadingOptions.shared.failureImage = UIImage(named: "chef_placeholder")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.3)
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
        super.onLoadingState()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func onResultsState() {
        chefsViewModel.elements = chefsViewModel.result
        DispatchQueue.main.async {
            self.collectionView.reloadData {
                self.viewDidLayoutSubviews()

                super.onResultsState()
            }
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView.scrollView {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            let offset = scrollView.contentOffset.y
            if translation.y > 0 && self.searchBarHeightConstraint.constant == 0 && offset <= 0 {
                // move up
                searchBarHeightConstraint.constant = 56
            } else if translation.y < 0 && self.searchBarHeightConstraint.constant == 56 {
                // move down
                searchBarHeightConstraint.constant = 0
            }

            UIView.animate(withDuration: 0.2, animations: { self.view.layoutIfNeeded() })
        }
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
