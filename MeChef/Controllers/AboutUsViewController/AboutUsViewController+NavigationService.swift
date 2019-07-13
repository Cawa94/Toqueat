import UIKit

extension NavigationService {

    static func aboutUsViewController() -> AboutUsViewController {
        let controller = AboutUsViewController(nibName: AboutUsViewController.xibName,
                                               bundle: nil)

        return controller
    }

}
