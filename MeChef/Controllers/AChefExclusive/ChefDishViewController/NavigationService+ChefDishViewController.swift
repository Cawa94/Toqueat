import UIKit

extension NavigationService {

    static func chefDishViewController(dishId: Int64?) -> ChefDishViewController {
        let controller = ChefDishViewController(nibName: ChefDishViewController.xibName,
                                                bundle: nil)
        let viewModel = ChefDishViewModel(dishId: dishId)

        controller.chefDishViewModel = viewModel
        return controller
    }

}
