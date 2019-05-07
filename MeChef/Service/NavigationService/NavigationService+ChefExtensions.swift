import UIKit

extension NavigationService {

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

    static var reloadChefDishes = false
    static var reloadChefOrders = false
    static var reloadChefProfile = false

    static func chefDishesTab(chefId: Int64) -> UIViewController {
        let chefDishesController = NavigationService.chefDishesViewController(chefId: chefId)
            .embedInNavigationController()
        chefDishesController.tabBarItem =
            UITabBarItem(title: "Dishes",
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefDishesController
    }

    static func chefOrderTab(chefId: Int64) -> UIViewController {
        let chefsController = NavigationService.chefOrdersViewController(chefId: chefId)
            .embedInNavigationController()
        chefsController.tabBarItem =
            UITabBarItem(title: "Orders",
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefsController
    }

    static func presentChefProfileController(chefId: Int64) {
        if SessionService.isLoggedIn {
            let profileController = chefProfileViewController(chefId: chefId).embedInNavigationController()
            rootNavigationController?.topVisibleViewController.present(profileController,
                                                                       animated: true,
                                                                       completion: nil)
        } else {
            makeLoginRootController()
        }
    }

    static func pushChefDeliverySlotsViewController(chefId: Int64, editable: Bool = false) {
        let deliverySlotsController = chefDeliverySlotsViewController(chefId: chefId,
                                                                      editable: editable)
        push(viewController: deliverySlotsController, animated: true)
    }

    static func pushChefDishViewController(dishId: Int64?) {
        let dishController = chefDishViewController(dishId: dishId)
        push(viewController: dishController, animated: true)
    }

    static func pushChefOrderDetailsViewController(orderId: Int64) {
        let orderDetailsController = chefOrderDetailsViewController(orderId: orderId)
        push(viewController: orderDetailsController, animated: true)
    }

}
