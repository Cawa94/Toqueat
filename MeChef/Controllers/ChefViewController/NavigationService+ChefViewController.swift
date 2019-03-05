import UIKit

extension NavigationService {

    static func chefViewController(chefId: Int64) -> ChefViewController {
        let controller = ChefViewController(nibName: ChefViewController.xibName,
                                            bundle: nil)
        let viewModel = ChefViewModel(chefId: chefId)

        controller.chefViewModel = viewModel
        return controller
    }

}
