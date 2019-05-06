import UIKit
import RxSwift

class DishesViewController: BaseTableViewController<[Dish], Dish>,
    UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBarContainerView: UIView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    var dishesViewModel: DishesViewModel! {
        didSet {
            tableViewModel = dishesViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private var filteredText: String?
    private var selectedCategoryId: Int64?
    private lazy var searchBar: UISearchBar = .toqueatSearchBar

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.frame = searchBarContainerView.bounds
        searchBarContainerView.addSubview(searchBar)
        searchBar.placeholder = "Search dishes"
        searchBar.delegate = self
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .skip(1)
            .debounce(0.5)
            .drive(onNext: { text in
                self.filteredText = text
                NetworkService.shared.searchDish(query: text,
                                                 categoryId: self.selectedCategoryId)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { filteredDishes in
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
                    NetworkService.shared.searchDish(query: self.filteredText,
                                                     categoryId: self.selectedCategoryId)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { filteredDishes in
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

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 60 // Dishes title
            + 80 // searchBar
            + 56 // filters collectionView
    }

}
