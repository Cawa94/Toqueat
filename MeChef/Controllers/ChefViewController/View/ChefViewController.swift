import UIKit
import RxSwift
import Nuke

class ChefViewController: BaseTableViewController<Chef, Dish> {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var chefDetailsTableView: IntrinsicTableView!
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

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chefDetailsTableView.roundCorners(radii: 15.0)
        chefImageView.roundOnly(corners: [.bottomLeft, .bottomRight], cornerRadii: 30.0)

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
        chefDetailsTableView.register(UINib(nibName: "ChefDetailsTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "ChefDetailsTableViewCell")
    }

    // MARK: - Actions

    @IBAction func closeAction(_ sender: Any) {
        NavigationService.popNavigationTopController()
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableViewModel.numberOfItems(for: section)
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == self.tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        } else {
            cell = chefDetailsTableView.dequeueReusableCell(withIdentifier: "ChefDetailsTableViewCell",
                                                            for: indexPath)
        }
        configure(cell, at: indexPath, isLoading: chefViewModel.isLoading)
        return cell
    }

    override func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            dishCell.configureWith(loading: true)
        case let chefDetailsCell as ChefDetailsTableViewCell:
            chefDetailsCell.configureWith(loading: true)
        default:
            break
        }
    }

    override func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = chefViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish,
                                               chef: nil)
            dishCell.configureWith(contentViewModel: viewModel)
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
        case let chefDetailsCell as ChefDetailsTableViewCell:
            let chef = chefViewModel.result
            chefDetailsCell.configureWith(contentViewModel: chef)
            chefDetailsCell.instaButton.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    guard let instaUrl = URL(string: "https://www.instagram.com/ewelina_happymamas/")
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 220
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            return 50
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            let  headerCell = UITableViewCell()
            headerCell.textLabel?.text = "My dishes"
            headerCell.textLabel?.textColor = .darkGrayColor
            headerCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            return headerCell
        }
        return nil
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        chefDetailsTableView.reloadData()
        super.onLoadingState()
    }

    override func onResultsState() {
        if let avatarUrl = chefViewModel.avatarUrl {
            Nuke.loadImage(with: avatarUrl, into: chefImageView)
            chefImageView.contentMode = .scaleAspectFill
        }
        chefViewModel.elements = chefViewModel.result.dishes ?? []
        chefDetailsTableView.reloadData()
        navigationTitle.text = "\(chefViewModel.result.name) \(chefViewModel.result.lastname)"
        super.onResultsState()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        chefDetailsHeightConstraint.constant = chefDetailsTableView.contentSize.height
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
