import UIKit

extension NavigationService {

    static func containerVolumeViewController() -> ContainerVolumeViewController {
        let controller = ContainerVolumeViewController(nibName: ContainerVolumeViewController.xibName,
                                                       bundle: nil)

        return controller
    }

}
