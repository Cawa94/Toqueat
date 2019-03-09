import UIKit

extension NavigationService {

    static func registerViewController() -> RegisterViewController {
        let controller = RegisterViewController(nibName: RegisterViewController.xibName,
                                                bundle: nil)
        let viewModel = RegisterViewModel()

        controller.registerViewModel = viewModel
        return controller
    }

}
