import UIKit

struct NavigationService {

    init() {}

    private static var appWindow: UIWindow {
        return AppDelegate.shared.appWindow
    }

    private static var navigationController: UINavigationController? {
        return appWindow.rootViewController?.topVisibleViewController.navigationController
    }

    private static var mainViewController: MainTabViewController? {
        return appWindow.rootViewController as? MainTabViewController
    }

    private static var rootNavigationController: UINavigationController? {
        return appWindow.rootViewController as? UINavigationController
    }

    private static func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

}

extension NavigationService {

    static func setRootController(controller: UIViewController) {
        appWindow.rootViewController = controller
    }

    static func pushChefViewController(chef: Chef) {
        let chefController = chefViewController(chef: chef)
        push(viewController: chefController, animated: true)
    }

    static func pushDishViewController(dish: Dish) {
        let dishController = dishViewController(dish: dish)
        push(viewController: dishController, animated: true)
    }

    static func pushRegisterViewController() {
        let registerController = registerViewController()
        push(viewController: registerController, animated: true)
    }

    static func loginOrProfileTab() -> UIViewController {
        let profileController = SessionService.isLoggedIn
            ? profileViewController()
            : loginViewController()
        profileController.tabBarItem =
            UITabBarItem(title: "Profile",
                         image: UIImage(named: "user_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "user_icon_on")?.withRenderingMode(.alwaysOriginal))
        return profileController
    }

    static func replaceLastTabItem() {
        mainViewController?.viewControllers?[2] = loginOrProfileTab().embedInNavigationController()
    }

}
