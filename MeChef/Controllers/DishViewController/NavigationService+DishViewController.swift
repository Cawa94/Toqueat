import UIKit

extension NavigationService {

    static func dishViewController(dish: Dish) -> DishViewController {
        let controller = DishViewController(nibName: DishViewController.xibName,
                                            bundle: nil)
        let viewModel = DishViewModel(dish: dish)

        controller.viewModel = viewModel
        return controller
    }

}
