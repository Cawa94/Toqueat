import UIKit

extension NavigationService {

    static func chefsViewController() -> ChefsViewController {
        let controller = ChefsViewController(nibName: ChefsViewController.xibName,
                                             bundle: nil)
        let viewModel = ChefsViewModel(chefsList: [])

        controller.viewModel = viewModel
        return controller
    }

}
