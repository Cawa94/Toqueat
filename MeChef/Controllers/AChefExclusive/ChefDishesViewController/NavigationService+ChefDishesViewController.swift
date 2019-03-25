import UIKit

extension NavigationService {

    static func chefDishesViewController(chefId: Int64) -> ChefDishesViewController {
        let controller = ChefDishesViewController(nibName: ChefDishesViewController.xibName,
                                                  bundle: nil)
        let viewModel = ChefDishesViewModel(chefId: chefId)

        controller.chefDishesViewModel = viewModel
        return controller
    }

}
