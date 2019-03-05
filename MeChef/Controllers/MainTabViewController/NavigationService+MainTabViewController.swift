import UIKit

extension NavigationService {

    static func mainTabViewController() -> MainTabViewController {
        let controller = MainTabViewController(nibName: MainTabViewController.xibName,
                                               bundle: nil)

        return controller
    }

}
