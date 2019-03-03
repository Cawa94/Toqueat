import UIKit

struct NavigationService {

    init() {}

    static var appWindow: UIWindow {
        return AppDelegate.shared.appWindow
    }

    static var navigationController: UINavigationController? {
        return appWindow.rootViewController?.topVisibleViewController.navigationController
    }

    static var mainViewController: MainTabViewController? {
        return rootNavigationController?.viewControllers.first as? MainTabViewController
    }

    static var rootNavigationController: UINavigationController? {
        return appWindow.rootViewController as? UINavigationController
    }

}
