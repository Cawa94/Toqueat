import UIKit
import RxSwift
import RxCocoa

class ChefProfileViewController: BaseStatefulController<Chef> {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    var chefProfileViewModel: ChefProfileViewModel! {
        didSet {
            viewModel = chefProfileViewModel
        }
    }

    private let disposeBag = DisposeBag()

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

    @IBAction func deliverySlotsAction(_ sender: Any) {
        NavigationService.pushChefDeliverySlotsViewController(chefId: chefProfileViewModel.result.id)
    }

    @IBAction func performLogout(_ sender: Any) {
        SessionService.logout()
        DispatchQueue.main.async {
            NavigationService.makeLoginRootController()
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        welcomeLabel.text = "Ciao Chef"
        nameLabel.text = chefProfileViewModel.name
        lastNameLabel.text = chefProfileViewModel.lastname
        emailLabel.text = chefProfileViewModel.email
        addressLabel.text = chefProfileViewModel.address
        zipcodeLabel.text = chefProfileViewModel.zipcode
        cityLabel.text = chefProfileViewModel.city
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
