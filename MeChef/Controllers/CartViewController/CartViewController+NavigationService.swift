import UIKit

extension NavigationService {

    static func cartViewController() -> CartViewController {
        let controller = CartViewController(nibName: CartViewController.xibName,
                                            bundle: nil)
        let viewModel = CartViewModel()

        controller.cartViewModel = viewModel
        return controller
    }

}
