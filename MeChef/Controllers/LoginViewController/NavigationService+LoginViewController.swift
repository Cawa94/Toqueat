import UIKit

extension NavigationService {

    static func loginViewController() -> LoginViewController {
        let controller = LoginViewController(nibName: LoginViewController.xibName,
                                             bundle: nil)
        let viewModel = LoginViewModel()

        controller.viewModel = viewModel
        return controller
    }

}
