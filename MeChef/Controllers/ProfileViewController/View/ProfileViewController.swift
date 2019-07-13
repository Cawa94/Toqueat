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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NavigationService.reloadUserProfile {
            profileViewModel.reload()
            NavigationService.reloadUserProfile = false
        }
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = .commonProfile()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .commonDone(),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(closeProfile))
    }

    @objc func closeProfile() {
        NavigationService.dismissTopController()
    }

    // MARK: - UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
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
            let viewModel = UserBaseInfoCellViewModel(baseUser: profileViewModel.baseUser,
                                                      isChef: false,
                                                      chefImageUrl: nil)
            baseInfoCell.configureWith(contentViewModel: viewModel)
        case let barCell as UserBarTableViewCell:
            let viewModel: UserBarTableViewModel
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    viewModel = UserBarTableViewModel(option: .profileMyOrders())
                case 1:
                    viewModel = UserBarTableViewModel(option: .profileMyAddress(), hideBottomLine: false)
                default:
                    viewModel = UserBarTableViewModel(option: "Unknown")
                }
            case 2:
                viewModel = UserBarTableViewModel(option: .aboutUsTitle(), hideBottomLine: false)
            case 3:
                viewModel = UserBarTableViewModel(option: .profileLogout(), arrowHidden: true, hideBottomLine: false)
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
        case 2:
            return 20
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
        guard !profileViewModel.isLoading
            else { return }
        switch indexPath.section {
        case 0:
            NavigationService.pushEditPeronalDetailsViewController()
        case 1:
            switch indexPath.row {
            case 0:
                NavigationService.pushOrdersViewController()
            case 1:
                NavigationService.pushEditAddressViewController()
            default:
                break
            }
        case 2:
            NavigationService.pushAboutUsViewController()
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
        super.onResultsState()

        tableView.reloadData()

        // Update session value to be sure is updated after editing info
        SessionService.updateWith(user: profileViewModel.result)

        super.onResultsState()
    }

    override func onLoadingState() {
        super.onLoadingState()

        tableView.reloadData()
    }

}
