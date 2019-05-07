import UIKit

extension NavigationService {

    static func trackOrderViewController(orderId: Int64) -> TrackOrderViewController {
        let controller = TrackOrderViewController(nibName: TrackOrderViewController.xibName,
                                                  bundle: nil)
        let viewModel = TrackOrderViewModel(orderId: orderId)

        controller.trackOrderViewModel = viewModel
        return controller
    }

}
