import UIKit

extension NavigationService {

    static func chefWeekplanViewController(chefId: Int64) -> ChefWeekplanViewController {
        let controller = ChefWeekplanViewController(nibName: ChefWeekplanViewController.xibName,
                                                  bundle: nil)
        let viewModel = ChefWeekplanViewModel(chefId: chefId)

        controller.chefWeekplanViewModel = viewModel
        return controller
    }

}
