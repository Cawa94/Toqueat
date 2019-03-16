import UIKit

extension NavigationService {

    static func checkoutViewController(cart: LocalCart) -> CheckoutViewController {
        let controller = CheckoutViewController(nibName: CheckoutViewController.xibName,
                                                bundle: nil)
        let viewModel = CheckoutViewModel(cart: cart)

        controller.checkoutViewModel = viewModel
        return controller
    }

}
