import UIKit
import RxSwift
import Nuke

class ChefViewController: BaseStatefulController<Chef>,
    UITableViewDelegate, UITableViewDataSource,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var chefDetailsTableView: IntrinsicTableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var chefImageView: UIImageView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var chefDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationTitle: UILabel!
    @IBOutlet private weak var navigationBar: UIView!
    @IBOutlet private weak var backArrowOrangeButton: UIButton!

    var chefViewModel: ChefViewModel! {
        didSet {
            viewModel = chefViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chefDetailsTableView.roundCorners(radii: 15.0)
        chefImageView.roundCorners(radii: chefImageView.bounds.height/2)

        chefDetailsTableView.register(UINib(nibName: "ChefDetailsTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "ChefDetailsTableViewCell")

        let nib = UINib(nibName: DishCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: DishCollectionViewCell.reuseID)
    }

    // MARK: - Actions

    @IBAction func closeAction(_ sender: Any) {
        NavigationService.popNavigationTopController()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = chefDetailsTableView.dequeueReusableCell(withIdentifier: "ChefDetailsTableViewCell",
                                                        for: indexPath)
        configure(cell, at: indexPath, isLoading: chefViewModel.isLoading)
        return cell
    }

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            dishCell.configureWith(loading: true)
        case let chefDetailsCell as ChefDetailsTableViewCell:
            chefDetailsCell.configureWith(loading: true)
        default:
            break
        }
    }

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefDetailsCell as ChefDetailsTableViewCell:
            let chef = chefViewModel.result
            chefDetailsCell.configureWith(contentViewModel: chef)
            chefDetailsCell.instaButton.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    guard let username = chef.instagramUsername,
                        let instaUrl = URL(string: "https://www.instagram.com/\(username)")
                        else { return }
                    NavigationService.presentSafariController(url: instaUrl)
                })
                .disposed(by: chefDetailsCell.disposeBag)
            chefDetailsCell.availabButton.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushChefDeliverySlotsViewController(chefId: self.chefViewModel.result.id)
                })
                .disposed(by: chefDetailsCell.disposeBag)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Collection view data source and delegate methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return chefViewModel.numberOfItems(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollectionViewCell",
                                                          for: indexPath)
            configure(cell, at: indexPath, isLoading: chefViewModel.isLoading)
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
        case let chefCell as DishCollectionViewCell:
            chefCell.configureWith(loading: true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishCollectionViewCell:
            let dish = chefViewModel.elementAt(indexPath.row)
            dishCell.configureWith(contentViewModel: dish)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = collectionView.bounds.width / CGFloat(ChefViewModel.Constants.numberOfColumns)
            - ChefViewModel.Constants.sectionInsets.left
        let width = columnWidth - (ChefViewModel.Constants.horizontalSpacingBetweenCells
            / CGFloat(ChefViewModel.Constants.numberOfColumns))

        return CGSize(width: width, height: ChefViewModel.Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return ChefViewModel.Constants.sectionInsets
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        super.onLoadingState()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func onResultsState() {
        if let avatarUrl = chefViewModel.avatarUrl {
            Nuke.loadImage(with: avatarUrl, into: chefImageView)
        } else {
            chefImageView.image = UIImage(named: "chef_placeholder")
        }
        chefImageView.contentMode = .scaleAspectFill
        chefViewModel.elements = chefViewModel.result.dishes ?? []
        chefDetailsTableView.reloadData()
        navigationTitle.text = "\(chefViewModel.result.name) \(chefViewModel.result.lastname)"
        DispatchQueue.main.async {
            self.collectionView.reloadData {
                self.viewDidLayoutSubviews()
            }
        }

        super.onResultsState()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = collectionView.contentSize.height
        chefDetailsHeightConstraint.constant = chefDetailsTableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 230 + chefDetailsHeightConstraint.constant + 30 + 50
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        let showNavigationBarY = CGFloat(60)
        let showNavigationLabelY = CGFloat(170)

        if offset < 0 {
            // PULL DOWN -----------------
            let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor))
                - headerView.bounds.height)/2.0

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0
                + headerScaleFactor, 90)
        } else {
            // SCROLL UP/DOWN ------------
            headerTransform = CATransform3DTranslate(headerTransform, 0, -offset, 0)
        }

        if offset >= showNavigationBarY {
            navigationBar.alpha = min (1.0, (offset - showNavigationBarY)/80)
        } else {
            navigationBar.alpha = 0.0
        }

        if offset >= (showNavigationLabelY) { // after top bar blocked, start showing label
            navigationTitle.alpha = min (1.0, (offset - showNavigationLabelY)/15)
            backArrowOrangeButton.alpha = min (1.0, (offset - showNavigationLabelY)/15)
        } else {
            navigationTitle.alpha = 0.0
            backArrowOrangeButton.alpha = 0.0
        }

        headerView.layer.transform = headerTransform
    }

}
