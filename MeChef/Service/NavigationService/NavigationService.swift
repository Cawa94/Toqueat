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

    static func dishesTab() -> UIViewController {
        let dishesController = NavigationService.dishesViewController().embedInNavigationController()
        dishesController.tabBarItem =
            UITabBarItem(title: "Dishes",
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))
        return dishesController
    }

    static func chefsTab() -> UIViewController {
        let chefsController = NavigationService.chefsViewController().embedInNavigationController()
        chefsController.tabBarItem =
            UITabBarItem(title: "Chefs",
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefsController
    }

    static func profileOrEmptyTab() -> UIViewController {
        var profileController: UIViewController
        if SessionService.isLoggedIn {
            profileController = profileViewController().embedInNavigationController()
        } else {
            profileController = UIViewController()
        }
        profileController.tabBarItem =
            UITabBarItem(title: "Profile",
                         image: UIImage(named: "user_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "user_icon_on")?.withRenderingMode(.alwaysOriginal))
        return profileController
    }

    static func makeMainTabRootController() {
        let mainTabController = NavigationService.mainTabViewController().embedInNavigationController()
        appWindow.changeRootController(controller: mainTabController)
    }

    static func makeLoginRootController() {
        let loginController = loginViewController().embedInNavigationController()
        appWindow.changeRootController(controller: loginController)
    }

    static func makeChefLoginRootController() {
        let chefLoginController = chefLoginViewController()
        appWindow.changeRootController(controller: chefLoginController)
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

    static func pushCartViewController(cart: LocalCart) {
        let cartController = cartViewController(cart: cart)
        rootNavigationController?.pushViewController(cartController, animated: true)
    }

    static func pushCheckoutViewController(cart: LocalCart, chefId: Int64) {
        let checkoutController = checkoutViewController(cart: cart,
                                                        chefId: chefId)
        rootNavigationController?.pushViewController(checkoutController, animated: true)
    }

    static func presentDeliverySlots(controller: DeliverySlotsViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        rootNavigationController?.topVisibleViewController.present(controller,
                                                                   animated: true,
                                                                   completion: nil)
    }

    static func dismissDeliverySlotsController() {
        rootNavigationController?.topVisibleViewController.dismiss(animated: true)
    }

    static func dismissCartNavigationController() {
        rootNavigationController?.popToRootViewController(animated: true)
    }

    static func presentAddress(controller: AddressViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        rootNavigationController?.topVisibleViewController.present(controller,
                                                                   animated: true,
                                                                   completion: nil)
    }

    static func dismissAddressController() {
        rootNavigationController?.topVisibleViewController.dismiss(animated: true)
    }

    static func chefDishesTab(chefId: Int64) -> UIViewController {
        let chefDishesController = NavigationService.chefDishesViewController(chefId: chefId)
        chefDishesController.tabBarItem =
            UITabBarItem(title: "Dishes",
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefDishesController
    }

    static func chefOrderTab(chefId: Int64) -> UIViewController {
        let chefsController = NavigationService.chefOrdersViewController(chefId: chefId)
        chefsController.tabBarItem =
            UITabBarItem(title: "Orders",
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefsController
    }

    static func chefProfileTab(chefId: Int64) -> UIViewController {
        let chefProfileController = NavigationService.chefProfileViewController(chefId: chefId)
        chefProfileController.tabBarItem =
            UITabBarItem(title: "Profile",
                         image: UIImage(named: "user_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "user_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefProfileController
    }

}
