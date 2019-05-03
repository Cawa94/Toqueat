import UIKit

extension NavigationService {

    static func editAddressViewController() -> EditAddressViewController {
        let controller = EditAddressViewController(nibName: EditAddressViewController.xibName,
                                                   bundle: nil)
        let viewModel = EditAddressViewModel(user: SessionService.session?.user,
                                             chef: SessionService.session?.chef)

        controller.editAddressViewModel = viewModel
        return controller
    }

}
