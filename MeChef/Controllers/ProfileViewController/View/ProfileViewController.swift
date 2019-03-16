import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseStatefulController<User> {

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

    @IBAction func performLogout(_ sender: Any) {
        SessionService.logout()
        DispatchQueue.main.async {
            NavigationService.replaceLastTabItem()
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        nameLabel.text = profileViewModel.name
        lastNameLabel.text = profileViewModel.lastname
        emailLabel.text = profileViewModel.email
        addressLabel.text = profileViewModel.address
        zipcodeLabel.text = profileViewModel.zipcode
        cityLabel.text = profileViewModel.city
        SessionService.updateWith(user: profileViewModel.result)
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
