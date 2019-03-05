import UIKit

extension NavigationService {

    static func chefViewController(chef: Chef) -> ChefViewController {
        let controller = ChefViewController(nibName: ChefViewController.xibName,
                                            bundle: nil)
        let viewModel = ChefViewModel(chef: chef)

        controller.viewModel = viewModel
        return controller
    }

}
