import UIKit

extension NavigationService {

    static func chefOrderDetailsViewController(order: Order) -> ChefOrderDetailsViewController {
        let controller = ChefOrderDetailsViewController(nibName: ChefOrderDetailsViewController.xibName,
                                                    bundle: nil)
        let viewModel = ChefOrderDetailsViewModel(order: order)

        controller.viewModel = viewModel
        return controller
    }

}
