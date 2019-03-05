import UIKit

extension NavigationService {

    static func dishesViewController() -> DishesViewController {
        let controller = DishesViewController(nibName: DishesViewController.xibName,
                                              bundle: nil)
        let viewModel = DishesViewModel()

        controller.dishesViewModel = viewModel
        return controller
    }

}
