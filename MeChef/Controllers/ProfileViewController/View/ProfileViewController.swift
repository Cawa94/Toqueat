import UIKit
import RxSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!

    var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = "Tu che hai fatto il login, bravo!"
        tokenLabel.text = SessionService.user?.authToken
    }

    @IBAction func performLogout(_ sender: Any) {
        SessionService.logout()
        DispatchQueue.main.async {
            NavigationService.replaceLastTabItem()
        }
    }

}
