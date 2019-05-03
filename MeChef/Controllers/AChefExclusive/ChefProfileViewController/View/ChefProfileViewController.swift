import UIKit
import RxSwift
import RxCocoa

class ChefProfileViewController: BaseStatefulController<Chef>,
    UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!

    var chefProfileViewModel: ChefProfileViewModel! {
        didSet {
            viewModel = chefProfileViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserBaseInfoTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UserBaseInfoTableViewCell")
        tableView.register(UINib(nibName: "UserBarTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UserBarTableViewCell")
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(closeProfile))
    }

    @objc func closeProfile() {
        NavigationService.dismissTopController()
    }

    // MARK: - UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "UserBaseInfoTableViewCell",
                                                 for: indexPath)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "UserBarTableViewCell",
                                                 for: indexPath)
        }
        configure(cell, at: indexPath, isLoading: chefProfileViewModel.isLoading)
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
        case let baseInfoCell as UserBaseInfoTableViewCell:
            baseInfoCell.configureWith(loading: true)
        default:
            break
        }
    }

    // swiftlint:disable all
    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let baseInfoCell as UserBaseInfoTableViewCell:
            let viewModel = UserBaseInfoCellViewModel(baseUser: chefProfileViewModel.baseChef,
                                                      isChef: true,
                                                      chefImageUrl: chefProfileViewModel.result.avatarLink)
            baseInfoCell.configureWith(contentViewModel: viewModel)
        case let barCell as UserBarTableViewCell:
            let viewModel: UserBarTableViewModel
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    viewModel = UserBarTableViewModel(option: "My Availability")
                case 1:
                    viewModel = UserBarTableViewModel(option: "My Address")
                case 2:
                    viewModel = UserBarTableViewModel(option: "My Orders")
                case 3:
                    viewModel = UserBarTableViewModel(option: "Notifications", hideBottomLine: false)
                default:
                    viewModel = UserBarTableViewModel(option: "Unknown")
                }
            case 2:
                viewModel = UserBarTableViewModel(option: "Log out", arrowHidden: true, hideBottomLine: false)
            default:
                viewModel = UserBarTableViewModel(option: "Unknown")
            }
            barCell.configureWith(contentViewModel: viewModel)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 90
        default:
            return 50
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return 40
        default:
            return 50
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UITableViewCell()
        headerCell.backgroundColor = .lightGrayBackgroundColor
        return headerCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !chefProfileViewModel.isLoading
            else { return }
        switch indexPath.section {
        case 0:
            NavigationService.pushEditPeronalDetailsViewController()
        case 1:
            switch indexPath.row {
            case 0:
                NavigationService.pushChefDeliverySlotsViewController(chefId: chefProfileViewModel.result.id,
                                                                      editable: true)
            case 1:
            break // Show Delivery Addresses
            case 2:
            break // Show Payment Methods
            case 3:
            break // Show Notifications
            default:
                break
            }
        default:
            SessionService.logout()
            DispatchQueue.main.async {
                NavigationService.makeLoginRootController()
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        tableView.reloadData()
    }

    override func onLoadingState() {
        tableView.reloadData()
    }

}
