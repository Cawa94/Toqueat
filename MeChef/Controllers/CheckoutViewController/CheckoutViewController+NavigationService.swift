import UIKit

extension NavigationService {

    static func checkoutViewController(cart: LocalCart,
                                       chefId: Int64) -> CheckoutViewController {
        let controller = CheckoutViewController(nibName: CheckoutViewController.xibName,
                                                bundle: nil)
        let viewModel = CheckoutViewModel(cart: cart,
                                          chefId: chefId)

        controller.checkoutViewModel = viewModel
        return controller
    }

}
