import UIKit
import RxSwift
import Nuke

class DishesViewController: BaseTableViewController<[BaseDish], BaseDish>,
    UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBarContainerView: UIView!
    @IBOutlet private weak var searchBarHeightConstraint: NSLayoutConstraint!

    var dishesViewModel: DishesViewModel! {
        didSet {
            tableViewModel = dishesViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var filteredText: String?
    private var selectedCategoryId: Int64?
    private lazy var searchBar: UISearchBar = .toqueatSearchBar
    private var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.scrollView.delegate = self

        searchBar.frame = searchBarContainerView.bounds
        searchBarContainerView.addSubview(searchBar)
        searchBar.placeholder = .mainSearchDish()
        searchBar.delegate = self
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .skip(1)
            .debounce(0.5)
            .drive(onNext: { text in
                self.startLoading(with: self.loadingStateView)
                self.filteredText = text.isNotEmpty ? text : nil
                NetworkService.shared.searchDish(query: text.isNotEmpty ? text : nil,
                                                 categoryId: self.selectedCategoryId)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { filteredDishes in
                        self.endLoading(with: self.loadingStateView)
                        self.dishesViewModel.elements = filteredDishes
                        self.tableView.reloadData()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
        let nib = UINib(nibName: "DishCategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: "DishCategoryCollectionViewCell")

        configureNuke()
    }

    func configureNuke() {
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFill,
            failure: .scaleAspectFit,
            placeholder: .scaleAspectFit)

        ImageLoadingOptions.shared.contentModes = contentModes
        ImageLoadingOptions.shared.placeholder = UIImage()
        ImageLoadingOptions.shared.failureImage = UIImage(named: "dish_placeholder")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.3)
    }

    @IBAction func profileAction(_ sender: Any) {
        NavigationService.presentProfileController()
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: dishesViewModel.isLoading)
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            dishCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = dishesViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish,
                                               chef: dish.chef)
            dishCell.configureWith(contentViewModel: viewModel)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
            if indexPath.row == dishesViewModel.elements.count - 1 {
                DispatchQueue.main.async {
                    self.viewDidLayoutSubviews()
                }
            }
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dishesViewModel.dishesTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCategoryCollectionViewCell",
                                                          for: indexPath)
            configureWithContent(cell, at: indexPath)
            return cell
    }

    private func configureWithContent(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let categoryCell as DishCategoryCollectionViewCell:
            let dishCategory = dishesViewModel.dishesTypes[indexPath.row]
            categoryCell.configureWith(dishCategory)
            categoryCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    let isActive = self.dishesViewModel.dishesTypes[indexPath.row].isActive
                    self.dishesViewModel.deselectFilters()
                    self.selectedCategoryId = isActive ? nil : dishCategory.paramId
                    self.dishesViewModel.dishesTypes[indexPath.row].isActive = !isActive
                    self.startLoading(with: self.loadingStateView)
                    NetworkService.shared.searchDish(query: self.filteredText,
                                                     categoryId: self.selectedCategoryId)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { filteredDishes in
                            self.endLoading(with: self.loadingStateView)
                            self.dishesViewModel.elements = filteredDishes
                            self.tableView.reloadData()
                        })
                        .disposed(by: self.disposeBag)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
                .disposed(by: categoryCell.disposeBag)
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        dishesViewModel.elements = dishesViewModel.result

        super.onResultsState()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView.scrollView {
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

}
