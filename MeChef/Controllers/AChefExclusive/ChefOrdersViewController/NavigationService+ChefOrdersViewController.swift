import UIKit

extension NavigationService {

    static func chefOrdersViewController(chefId: Int64) -> ChefOrdersViewController {
        let controller = ChefOrdersViewController(nibName: ChefOrdersViewController.xibName,
                                                  bundle: nil)
        let viewModel = ChefOrdersViewModel(chefId: chefId)

        controller.chefOrdersViewModel = viewModel
        return controller
    }

}
