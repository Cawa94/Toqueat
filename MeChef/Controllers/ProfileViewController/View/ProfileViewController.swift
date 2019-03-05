import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseStatefulController<User> {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var profileViewModel: ProfileViewModel! {
        didSet {
            viewModel = profileViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func performLogout(_ sender: Any) {
        SessionService.logout()
        DispatchQueue.main.async {
            NavigationService.replaceLastTabItem()
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        self.nameLabel.text = profileViewModel.result?.name
        self.lastNameLabel.text = profileViewModel.result?.lastname
        self.emailLabel.text = profileViewModel.result?.email
    }

    override func onLoadingState() {
        self.nameLabel.text = "LOADING"
        self.lastNameLabel.text = "LOADING"
        self.emailLabel.text = "LOADING"
    }

}
