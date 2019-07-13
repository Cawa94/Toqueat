import UIKit
import MessageUI

class AboutUsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        versionLabel.text = "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? 1.00)"

        tableView.register(UINib(nibName: "UserBarTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UserBarTableViewCell")
    }

    override func configureNavigationBar() {
        title = .aboutUsTitle()
    }

}

extension AboutUsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBarTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: false)
        return cell
    }

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        configureWithContent(cell, at: indexPath)
    }

    func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let baseInfoCell as UserBaseInfoTableViewCell:
            baseInfoCell.configureWith(loading: true)
        default:
            break
        }
    }

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let barCell as UserBarTableViewCell:
            let viewModel: UserBarTableViewModel
            switch indexPath.row {
            case 0:
                viewModel = UserBarTableViewModel(option: "Contact Us", hideBottomLine: false)
            case 1:
                viewModel = UserBarTableViewModel(option: "Rate us on the App Store", hideBottomLine: false)
            default:
                viewModel = UserBarTableViewModel(option: "Unknown")
            }
            barCell.configureWith(contentViewModel: viewModel)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Send email
            break
        case 1:
            // Rate on the app store
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

extension AboutUsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        navigationController?.topVisibleViewController.dismiss(animated: true, completion: nil)
    }

}
