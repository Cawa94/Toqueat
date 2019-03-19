import UIKit

extension NavigationService {

    static func chefLoginViewController() -> ChefLoginViewController {
        let controller = ChefLoginViewController(nibName: ChefLoginViewController.xibName,
                                                 bundle: nil)
        return controller
    }

}
