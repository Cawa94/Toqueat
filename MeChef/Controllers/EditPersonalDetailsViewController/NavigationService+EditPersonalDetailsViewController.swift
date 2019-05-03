import UIKit

extension NavigationService {

    static func editPersonalDetailsViewController() -> EditPersonalDetailsViewController {
        let controller = EditPersonalDetailsViewController(nibName: EditPersonalDetailsViewController.xibName,
                                                           bundle: nil)
        let viewModel = EditPersonalDetailsViewModel(user: SessionService.session?.user,
                                                     chef: SessionService.session?.chef)

        controller.viewModel = viewModel
        return controller
    }

}
