import UIKit

extension NavigationService {

    static func chefDeliverySlotsViewController(chefId: Int64) -> ChefDeliverySlotsViewController {
        let controller = ChefDeliverySlotsViewController(nibName: ChefDeliverySlotsViewController.xibName,
                                                         bundle: nil)
        let viewModel = ChefDeliverySlotsViewModel(chefId: chefId)

        controller.chefDeliverySlotsViewModel = viewModel
        return controller
    }

}
