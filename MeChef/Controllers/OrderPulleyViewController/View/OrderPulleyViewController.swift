import UIKit
import Pulley
import MapKit

class OrderPulleyViewController: BaseStatefulController<OrderPulleyViewModel.ResultType> {

    @IBOutlet private weak var contentContainerView: UIView!

    var orderPulleyViewModel: OrderPulleyViewModel! {
        didSet {
            viewModel = orderPulleyViewModel
        }
    }

    private var mapController: TrackOrderViewController {
        let mapController = TrackOrderViewController(nibName: TrackOrderViewController.xibName,
                                                     bundle: nil)

        mapController.viewModel = orderPulleyViewModel.trackOrderViewModel

        return mapController
    }

    private var orderDetailsController: OrderDetailsViewController {
        let orderController = OrderDetailsViewController(nibName: OrderDetailsViewController.xibName,
                                                             bundle: nil)

        orderController.viewModel = orderPulleyViewModel.orderDetailsViewModel

        return orderController
    }

    private lazy var pulleyController: PulleyViewController = {
        let pulleyController = PulleyViewController(contentViewController: mapController,
                                                    drawerViewController: orderDetailsController)

        pulleyController.initialDrawerPosition = .open
        pulleyController.drawerCornerRadius = 50.0
        pulleyController.backgroundDimmingColor = .clear
        pulleyController.shadowRadius = 50.0
        //pulleyController.drawerTopInset = -40

        return pulleyController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        embed(viewController: pulleyController, into: contentContainerView)
    }

    override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = .orderDetailsTitle()
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        // Show map only if Stuart Job status is "in_progress"
        // Check also if is driver is going to chef or customerh house and decide on that if show map

        if let orderDetailsController = self.pulleyController.drawerContentViewController
            as? OrderDetailsViewController {
            orderDetailsController.viewModel = orderPulleyViewModel.orderDetailsViewModel
            orderDetailsController.scrollView.delegate = self
            orderDetailsController.onResultState()
            orderPulleyViewModel.stuartJobDriver.drive(onNext: { _ in
                orderDetailsController.updateEtaText()
            })
                .disposed(by: orderDetailsController.disposeBag)
        }

        if orderPulleyViewModel.deliveryInProgress {
            if let mapController = self.pulleyController.primaryContentViewController as? TrackOrderViewController {
                mapController.viewModel = orderPulleyViewModel.trackOrderViewModel
                mapController.onResultState()
                orderPulleyViewModel.stuartJobDriver.drive(onNext: { result in
                    guard let latitude = result.stuartJob?.driver?.latitude,
                        let longitude = result.stuartJob?.driver?.longitude
                        else { return }
                    let courierCoordiante = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude),
                                                                   longitude: CLLocationDegrees(truncating: longitude))
                    mapController.updateCourierLocation(courierCoordiante)
                })
                    .disposed(by: mapController.disposeBag)
            }
            pulleyController.setDrawerPosition(position: .partiallyRevealed, animated: true)
        } else {
            pulleyController.allowsUserDrawerPositionChange = false
        }

        super.onResultsState()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y

        if scrollOffset < 0 && pulleyController.allowsUserDrawerPositionChange {
            // PULL DOWN -----------------
            pulleyController.setDrawerPosition(position: .partiallyRevealed, animated: true)
        } else if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
            // then we are at the end
            pulleyController.setDrawerPosition(position: .open, animated: true)
        }

    }

}
