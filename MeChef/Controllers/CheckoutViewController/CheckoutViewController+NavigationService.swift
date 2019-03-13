import UIKit

extension NavigationService {

    static func checkoutViewController(userId: Int64) -> CheckoutViewController {
        let controller = CheckoutViewController(nibName: CheckoutViewController.xibName,
                                                bundle: nil)
        let viewModel = CheckoutViewModel(userId: userId)

        controller.checkoutViewModel = viewModel
        return controller
    }

}
