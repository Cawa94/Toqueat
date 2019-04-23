import UIKit
import RxSwift
import Nuke

class DishViewController: BaseStatefulController<Dish>,
    UITableViewDelegate, UITableViewDataSource {

    enum Constants {
        static let cartTopConstraint: CGFloat = 60
    }

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var whiteBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var whiteBackgroundView: UIView!
    @IBOutlet private weak var tableView: IntrinsicTableView!
    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var openCartButton: RoundedButton!
    @IBOutlet private weak var openCartButtonTopConstraint: NSLayoutConstraint!

    var dishViewModel: DishViewModel! {
        didSet {
            viewModel = dishViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        whiteBackgroundView.roundOnly(corners: [.topLeft, .topRight], cornerRadii: 30.0)
        tableView.roundOnly(corners: [.topLeft, .topRight], cornerRadii: 30.0)

        let openCartModel = RoundedButtonViewModel(title: "Open cart", type: .squeezedOrange)
        openCartButton.configure(with: openCartModel)

        tableView.register(UINib(nibName: "DishDetailsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishDetailsTableViewCell")
        tableView.register(UINib(nibName: "ChefBaseInfoTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefBaseInfoTableViewCell")

    }

    // MARK: - Actions

    func addToCartAction() {
        guard let baseChef = self.dishViewModel.baseChef, !SessionService.isChef
            else { return }
        if let currentChef = CartService.localCart?.chef?.id, currentChef != dishViewModel.chefId {
            presentAlertWith(title: "WARNING", message: "You're gonna lose all your products",
                             actions: [UIAlertAction(title: "Proceed", style: .default, handler: { _ in
                                CartService.clearCart()
                                CartService.addToCart(self.dishViewModel.localCartDish,
                                                      chef: baseChef)
                             }),
                                       UIAlertAction(title: "Cancel", style: .cancel, handler: nil)])
            return
        }
        CartService.addToCart(dishViewModel.localCartDish, chef: baseChef)
    }

    @IBAction func removeFromCartAction(_ sender: Any) {
        CartService.removeFromCart(dishViewModel.localCartDish)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        tableView.reloadData()
        if let imageUrl = dishViewModel.imageUrl {
            Nuke.loadImage(with: imageUrl, into: dishImageView)
        } else {
            dishImageView.image = UIImage(named: "dish_placeholder")
        }
        dishImageView.contentMode = .scaleAspectFill
    }

    override func onLoadingState() {
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        whiteBackgroundHeightConstraint.constant = tableView.contentSize.height + 70 // bottom white space
        contentViewHeightConstraint.constant = whiteBackgroundHeightConstraint.constant + 260
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity

        if offset < 0 {
            // PULL DOWN -----------------
            let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor))
                - headerView.bounds.height)/2.0

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0
                + headerScaleFactor, 90)
        }

        headerView.layer.transform = headerTransform
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailsTableViewCell",
                                                 for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ChefBaseInfoTableViewCell",
                                                 for: indexPath)
        default:
            cell = UITableViewCell()
        }
        configure(cell, at: indexPath, isLoading: dishViewModel.isLoading)
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
        case let dishCell as DishDetailsTableViewCell:
            dishCell.configureWith(loading: true)
        case let chefCell as ChefBaseInfoTableViewCell:
            chefCell.configureWith(loading: true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishDetailsTableViewCell:
            let dish = dishViewModel.result
            dishCell.configureWith(contentViewModel: dish)
            dishCell.addToCartButton.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    self.addToCartAction()
                })
                .disposed(by: dishCell.disposeBag)
        case let chefCell as ChefBaseInfoTableViewCell:
            let chef = dishViewModel.result.chef
            chefCell.configureWith(contentViewModel: chef)
            chefCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    let chefController = NavigationService.chefViewController(chefId: self.dishViewModel.chefId)
                    NavigationService.pushChefViewController(chefController)
                })
                .disposed(by: chefCell.disposeBag)
            DispatchQueue.main.async {
                self.viewDidLayoutSubviews()
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
