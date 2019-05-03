import UIKit

extension NavigationService {

    static func ordersViewController() -> OrdersViewController {
        let controller = OrdersViewController(nibName: OrdersViewController.xibName,
                                              bundle: nil)
        let viewModel = OrdersViewModel()

        controller.ordersViewModel = viewModel
        return controller
    }

}
