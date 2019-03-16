import UIKit

extension NavigationService {

    static func cartViewController(cart: LocalCart) -> CartViewController {
        let controller = CartViewController(nibName: CartViewController.xibName,
                                            bundle: nil)
        let viewModel = CartViewModel(cart: cart)

        controller.cartViewModel = viewModel
        return controller
    }

}
