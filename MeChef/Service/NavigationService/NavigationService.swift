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
        return rootNavigationController?.viewControllers.first as? MainTabViewController
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

    static func dishesControllerTab() -> UIViewController {
        let dishesController = NavigationService.dishesViewController().embedInNavigationController()
        dishesController.tabBarItem =
            UITabBarItem(title: "Dishes",
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))
        return dishesController
    }

    static func chefsControllerTab() -> UIViewController {
        let chefsController = NavigationService.chefsViewController().embedInNavigationController()
        chefsController.tabBarItem =
            UITabBarItem(title: "Chefs",
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefsController
    }

    static func loginOrProfileTab() -> UIViewController {
        let profileController = SessionService.isLoggedIn
            ? profileViewController().embedInNavigationController()
            : loginViewController().embedInNavigationController()
        profileController.tabBarItem =
            UITabBarItem(title: "Profile",
                         image: UIImage(named: "user_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "user_icon_on")?.withRenderingMode(.alwaysOriginal))
        return profileController
    }

    static func replaceLastTabItem() {
        mainViewController?.reloadProfileController()
    }

    static func reloadMainTabControllers() {
        mainViewController?.reloadDishesChefsControllers()
    }

    static func pushChefViewController(chefId: Int64) {
        let chefController = chefViewController(chefId: chefId)
        push(viewController: chefController, animated: true)
    }

    static func pushDishViewController(dishId: Int64) {
        let dishController = dishViewController(dishId: dishId)
        push(viewController: dishController, animated: true)
    }

    static func pushRegisterViewController() {
        let registerController = registerViewController()
        push(viewController: registerController, animated: true)
    }

    static func pushCartViewController(userId: Int64) {
        let cartController = cartViewController(userId: userId)
        rootNavigationController?.pushViewController(cartController, animated: true)
    }

}
