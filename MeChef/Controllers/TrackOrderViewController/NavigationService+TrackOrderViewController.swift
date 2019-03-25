import UIKit

extension NavigationService {

    static func trackOrderViewController(orderId: Int64,
                                         stuartId: Int64?) -> TrackOrderViewController {
        let controller = TrackOrderViewController(nibName: TrackOrderViewController.xibName,
                                                  bundle: nil)
        let viewModel = TrackOrderViewModel(orderId: orderId,
                                            stuartId: stuartId)

        controller.trackOrderViewModel = viewModel
        return controller
    }

}
