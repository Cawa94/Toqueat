import UIKit

extension NavigationService {

    static func cartViewController(userId: Int64) -> CartViewController {
        let controller = CartViewController(nibName: CartViewController.xibName,
                                            bundle: nil)
        let viewModel = CartViewModel(userId: userId)

        controller.cartViewModel = viewModel
        return controller
    }

}
