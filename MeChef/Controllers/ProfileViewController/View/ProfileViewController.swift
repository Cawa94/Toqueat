import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseStatefulController<User>,
    UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!

    var profileViewModel: ProfileViewModel! {
        didSet {
            viewModel = profileViewModel
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
        configure(cell, at: indexPath, isLoading: profileViewModel.isLoading)
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
            let viewModel = profileViewModel.baseUser
            baseInfoCell.configureWith(contentViewModel: viewModel)
        case let barCell as UserBarTableViewCell:
            let viewModel: UserBarViewModel
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    viewModel = UserBarViewModel(option: "My Orders")
                case 1:
                    viewModel = UserBarViewModel(option: "Delivery Address")
                case 2:
                    viewModel = UserBarViewModel(option: "Payment Methods")
                case 3:
                    viewModel = UserBarViewModel(option: "Notifications")
                default:
                    viewModel = UserBarViewModel(option: "Unknown")
                }
            case 2:
                viewModel = UserBarViewModel(option: "Log out", arrowHidden: true)
            default:
                viewModel = UserBarViewModel(option: "Unknown")
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
            return 60
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
        headerCell.backgroundColor = .placeholderPampasColor
        return headerCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !profileViewModel.isLoading
            else { return }
        switch indexPath.section {
        case 0:
            break // Show User Details
        case 1:
            switch indexPath.row {
            case 0:
                NavigationService.pushOrdersViewController(userId: profileViewModel.result.id)
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
