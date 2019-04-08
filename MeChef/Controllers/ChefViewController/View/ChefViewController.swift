import UIKit
import RxSwift
import Nuke

class ChefViewController: BaseTableViewController<Chef, Dish> {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var chefDetailsView: ChefDetailsView!
    @IBOutlet private weak var chefImageView: UIImageView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var chefDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationTitle: UILabel!
    @IBOutlet private weak var navigationBar: UIView!

    var chefViewModel: ChefViewModel! {
        didSet {
            tableViewModel = chefViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        chefDetailsView.roundCorners(radii: 15.0)
        chefImageView.roundOnly(corners: [.bottomLeft, .bottomRight], cornerRadii: 30.0)

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
    }

    // MARK: - Actions

    @IBAction func showChefAvailabilityAction(_ sender: Any) {
        NavigationService.pushChefDeliverySlotsViewController(chefId: chefViewModel.result.id)
    }

    @IBAction func closeAction(_ sender: Any) {
        NavigationService.popNavigationTopController()
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: chefViewModel.isLoading)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    private func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            dishCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = chefViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish,
                                               chef: nil)
            dishCell.configureWithLoading( contentViewModel: viewModel)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dishId: dish.id)
                })
                .disposed(by: dishCell.disposeBag)
            if indexPath.row == chefViewModel.elements.count - 1 {
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = UITableViewCell()
        headerCell.textLabel?.text = "My dishes"
        headerCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        return headerCell
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        chefDetailsView.configureWith(loading: true)
        super.onLoadingState()
    }

    override func onResultsState() {
        if let avatarUrl = chefViewModel.avatarUrl {
            Nuke.loadImage(with: avatarUrl, into: chefImageView)
            chefImageView.contentMode = .scaleAspectFill
        }
        chefViewModel.elements = chefViewModel.result.dishes ?? []
        chefDetailsView.configureWith(contentViewModel: chefViewModel.result)
        navigationTitle.text = "\(chefViewModel.result.name) \(chefViewModel.result.lastname)"
        super.onResultsState()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + 190 + chefDetailsHeightConstraint.constant + 30
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        let blockProfileImageY = CGFloat(120)

        if offset < 0 {
            // PULL DOWN -----------------
            let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor))
                - headerView.bounds.height)/2.0

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0
                + headerScaleFactor, 90)
        }

        if offset >= 30 {
            navigationBar.alpha = min (1.0, (offset - 30)/80)
        } else {
            navigationBar.alpha = 0.0
        }

        if offset >= (blockProfileImageY) { // after top bar blocked, start showing label
            navigationTitle.alpha = min (1.0, (offset - blockProfileImageY)/15)
        } else {
            navigationTitle.alpha = 0.0
        }

        headerView.layer.transform = headerTransform
    }

}
