import UIKit

extension NavigationService {

    static func loginViewController() -> LoginViewController {
        let controller = LoginViewController(nibName: LoginViewController.xibName,
                                             bundle: nil)
        return controller
    }

}
