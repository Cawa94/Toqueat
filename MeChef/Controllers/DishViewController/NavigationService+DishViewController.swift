import UIKit

extension NavigationService {

    static func dishViewController(dishId: Int64) -> DishViewController {
        let controller = DishViewController(nibName: DishViewController.xibName,
                                            bundle: nil)
        let viewModel = DishViewModel(dishId: dishId)

        controller.dishViewModel = viewModel
        return controller
    }

}
