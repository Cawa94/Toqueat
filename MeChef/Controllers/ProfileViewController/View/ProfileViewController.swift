import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseStatefulController<User> {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

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
        nameLabel.text = profileViewModel.result.name
        lastNameLabel.text = profileViewModel.result.lastname
        emailLabel.text = profileViewModel.result.email
        cityLabel.text = profileViewModel.result.city.name
        SessionService.updateWith(user: BaseResultWithIdAndName(id: profileViewModel.result.id,
                                                                name: profileViewModel.result.name),
                                  city: profileViewModel.result.city)
    }

    override func onLoadingState() {
        nameLabel.text = "LOADING"
        lastNameLabel.text = "LOADING"
        emailLabel.text = "LOADING"
        cityLabel.text = "LOADING"
    }

}
