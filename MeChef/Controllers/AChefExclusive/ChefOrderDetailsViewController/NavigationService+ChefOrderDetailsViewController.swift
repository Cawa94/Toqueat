import UIKit

extension NavigationService {

    static func chefOrderDetailsViewController(orderId: Int64) -> ChefOrderDetailsViewController {
        let controller = ChefOrderDetailsViewController(nibName: ChefOrderDetailsViewController.xibName,
                                                        bundle: nil)
        let viewModel = ChefOrderDetailsViewModel(orderId: orderId)

        controller.chefOrderDetailsViewModel = viewModel
        return controller
    }

}
