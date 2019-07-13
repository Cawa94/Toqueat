import UIKit

extension NavigationService {

    static func registerViewController(asChef: Bool) -> RegisterViewController {
        let controller = RegisterViewController(nibName: RegisterViewController.xibName,
                                                bundle: nil)
        let viewModel = RegisterViewModel(asChef: asChef)

        controller.registerViewModel = viewModel
        return controller
    }

}
