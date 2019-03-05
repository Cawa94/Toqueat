import UIKit

extension NavigationService {

    static func profileViewController() -> ProfileViewController {
        let controller = ProfileViewController(nibName: ProfileViewController.xibName,
                                               bundle: nil)
        let viewModel = ProfileViewModel()

        controller.viewModel = viewModel
        return controller
    }

}
