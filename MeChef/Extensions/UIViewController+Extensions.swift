import UIKit

extension UIViewController {

    /// Return top visible controller even if we have inner UI(Navigation/TabBar)Controller's inside
    var topVisibleViewController: UIViewController {
        switch self {
        case let navController as UINavigationController:
            return navController.visibleViewController?.topVisibleViewController ?? navController
        case let tabController as UITabBarController:
            return tabController.selectedViewController?.topVisibleViewController ?? tabController
        default:
            return self.presentedViewController?.topVisibleViewController ?? self
        }
    }

    open class var xibName: String {
        return String(describing: self)
    }

    func embedInNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)

        navController.isNavigationBarHidden = true
        return navController
    }

    func presentAlertWith(title: String, message: String, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            _ = actions.compactMap {
                alert.addAction($0)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }

}
