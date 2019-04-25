import UIKit

extension NavigationService {

    static func orderDetailsViewController(order: Order) -> OrderDetailsViewController {
        let controller = OrderDetailsViewController(nibName: OrderDetailsViewController.xibName,
                                                    bundle: nil)
        let viewModel = OrderDetailsViewModel(order: order)

        controller.viewModel = viewModel
        return controller
    }

}
