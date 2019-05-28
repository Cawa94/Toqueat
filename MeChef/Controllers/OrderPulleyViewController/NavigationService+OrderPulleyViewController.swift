import UIKit

extension NavigationService {

    static func orderPulleyViewController(orderId: Int64,
                                          stuartId: Int64?) -> OrderPulleyViewController {
        let controller = OrderPulleyViewController(nibName: OrderPulleyViewController.xibName,
                                                   bundle: nil)
        let viewModel = OrderPulleyViewModel(orderId: orderId, stuartId: stuartId)

        controller.orderPulleyViewModel = viewModel
        return controller
    }

}
