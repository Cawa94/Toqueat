import UIKit

extension NavigationService {

    static func chefDeliverySlotsViewController(chefId: Int64,
                                                editable: Bool) -> ChefDeliverySlotsViewController {
        let controller = ChefDeliverySlotsViewController(nibName: ChefDeliverySlotsViewController.xibName,
                                                         bundle: nil)
        let viewModel = ChefDeliverySlotsViewModel(chefId: chefId,
                                                   editable: editable)

        controller.chefDeliverySlotsViewModel = viewModel
        return controller
    }

}
