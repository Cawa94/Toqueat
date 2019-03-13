import UIKit

extension NavigationService {

    static func deliverySlotsViewController(chefId: Int64) -> DeliverySlotsViewController {
        let controller = DeliverySlotsViewController(nibName: DeliverySlotsViewController.xibName,
                                                     bundle: nil)
        let viewModel = DeliverySlotsViewModel(chefId: chefId)

        controller.deliverySlotsViewModel = viewModel
        return controller
    }

}
