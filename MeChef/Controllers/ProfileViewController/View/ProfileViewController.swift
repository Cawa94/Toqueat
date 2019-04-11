import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseStatefulController<User> {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    var profileViewModel: ProfileViewModel! {
        didSet {
            viewModel = profileViewModel
        }
    }

    private let disposeBag = DisposeBag()

    @IBAction func viewOrdersAction(_ sender: Any) {
        guard !profileViewModel.isLoading
            else { return }
        NavigationService.pushOrdersViewController(userId: profileViewModel.userId)
    }

    @IBAction func performLogout(_ sender: Any) {
        SessionService.logout()
        DispatchQueue.main.async {
            NavigationService.makeLoginRootController()
        }
    }

    @IBAction func closeProfileAction(_ sender: Any) {
        NavigationService.dismissTopController()
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        welcomeLabel.text = "Ciao utente normale"
        nameLabel.text = profileViewModel.name
        lastNameLabel.text = profileViewModel.lastname
        emailLabel.text = profileViewModel.email
        addressLabel.text = profileViewModel.address
        zipcodeLabel.text = profileViewModel.zipcode
        cityLabel.text = profileViewModel.city
    }

    override func onLoadingState() {
        nameLabel.text = "LOADING"
        lastNameLabel.text = "LOADING"
        emailLabel.text = "LOADING"
        addressLabel.text = "LOADING"
        zipcodeLabel.text = "LOADING"
        cityLabel.text = "LOADING"
    }

}
