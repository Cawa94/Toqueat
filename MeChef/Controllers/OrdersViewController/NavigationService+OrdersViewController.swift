import UIKit

extension NavigationService {

    static func ordersViewController(userId: Int64) -> OrdersViewController {
        let controller = OrdersViewController(nibName: OrdersViewController.xibName,
                                              bundle: nil)
        let viewModel = OrdersViewModel(userId: userId)

        controller.ordersViewModel = viewModel
        return controller
    }

}
