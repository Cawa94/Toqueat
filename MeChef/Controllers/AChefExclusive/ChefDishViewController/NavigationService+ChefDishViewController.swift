import UIKit

extension NavigationService {

    static func chefDishViewController(dish: Dish?, chefId: Int64) -> ChefDishViewController {
        let controller = ChefDishViewController(nibName: ChefDishViewController.xibName,
                                                bundle: nil)
        let viewModel = ChefDishViewModel(dish: dish, chefId: chefId)

        controller.chefDishViewModel = viewModel
        return controller
    }

}
