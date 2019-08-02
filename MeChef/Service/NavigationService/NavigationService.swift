import UIKit
import SafariServices
import MessageUI

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

    static var reloadUserProfile = false

    static func setRootController(controller: UIViewController) {
        appWindow.rootViewController = controller
    }

    static func dishesTab() -> UIViewController {
        let dishesController = NavigationService.dishesViewController().embedInNavigationController()
        dishesController.tabBarItem =
            UITabBarItem(title: .commonDishes(),
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))
        return dishesController
    }

    static func chefsTab() -> UIViewController {
        let chefsController = NavigationService.chefsViewController().embedInNavigationController()
        chefsController.tabBarItem =
            UITabBarItem(title: .commonChefs(),
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))
        return chefsController
    }

    static func cartTab() -> UIViewController {
        let cartController = NavigationService.cartViewController().embedInNavigationController()
        cartController.tabBarItem =
            UITabBarItem(title: "",
                         image: UIImage(named: "cart_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "cart_icon_on")?.withRenderingMode(.alwaysOriginal))
        return cartController
    }

    static func presentProfileController() {
        if SessionService.isLoggedIn {
            let profileController = profileViewController().embedInNavigationController()
            rootNavigationController?.topVisibleViewController.present(profileController,
                                                                       animated: true,
                                                                       completion: nil)
        } else {
            makeLoginRootController()
        }
    }

    static func makeMainTabRootController() {
        let mainTabController = NavigationService.mainTabViewController().embedInNavigationController()
        appWindow.changeRootController(controller: mainTabController)
    }

    static func makeLoginRootController() {
        let loginController = loginViewController()
        appWindow.changeRootController(controller: loginController)
    }

    static func makeChefLoginRootController() {
        let chefLoginController = chefLoginViewController()
        appWindow.changeRootController(controller: chefLoginController)
    }

    static func pushChefViewController(_ controller: ChefViewController) {
        push(viewController: controller, animated: true)
    }

    static func pushDishViewController(dishId: Int64) {
        let dishController = dishViewController(dishId: dishId)
        push(viewController: dishController, animated: true)
    }

    static func makeRegisterRootController(asChef: Bool) {
        let registerController = registerViewController(asChef: asChef).embedInNavigationController()
        appWindow.changeRootController(controller: registerController)
    }

    static func pushOrdersViewController() {
        let ordersController = ordersViewController()
        push(viewController: ordersController, animated: true)
    }

    static func pushEditPeronalDetailsViewController() {
        let editDetailsController = editPersonalDetailsViewController()
        push(viewController: editDetailsController, animated: true)
    }

    static func pushEditAddressViewController() {
        let editAddressController = editAddressViewController()
        push(viewController: editAddressController, animated: true)
    }

    static func pushAboutUsViewController() {
        let aboutUsController = aboutUsViewController()
        push(viewController: aboutUsController, animated: true)
    }

    static func pushOrderPulleyViewController(orderId: Int64, stuartId: Int64?) {
        let orderPulleyController = orderPulleyViewController(orderId: orderId,
                                                              stuartId: stuartId)
        push(viewController: orderPulleyController, animated: true)
    }

    static func pushCheckoutViewController(cart: LocalCart, chefId: Int64) {
        let checkoutController = checkoutViewController(cart: cart,
                                                        chefId: chefId)
        push(viewController: checkoutController, animated: true)
    }

    static func presentDeliverySlots(controller: DeliverySlotsViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        rootNavigationController?.topVisibleViewController.present(controller,
                                                                   animated: true,
                                                                   completion: nil)
    }

    static func dismissTopController() {
        rootNavigationController?.topVisibleViewController.dismiss(animated: true)
    }

    static func popNavigationTopController() {
        navigationController?.popViewController(animated: true)
    }

    static func dismissCartNavigationController() {
        navigationController?.popToRootViewController(animated: true)
    }

    static func presentAddress(controller: AddressViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        rootNavigationController?.topVisibleViewController.present(controller,
                                                                   animated: true,
                                                                   completion: nil)
    }

    static func presentSafariController(url: URL) {
        let safariController = SFSafariViewController(url: url)
        navigationController?.present(safariController, animated: true, completion: nil)
    }

    static func topControllerPresentAlertWith(title: String, message: String) {
        appWindow.rootViewController?.presentAlertWith(title: title, message: message)
    }

    static func pushDeliverySlotsViewController(chefId: Int64) {
        let deliverySlotsController = deliverySlotsViewController(chefId: chefId)
        push(viewController: deliverySlotsController, animated: true)
    }

    static func pushWebViewController(_ webController: WebViewController) {
        push(viewController: webController, animated: true)
    }

    static func presentMailController(controller: MFMailComposeViewController) {
        navigationController?.present(controller, animated: true, completion: nil)
    }

    static func presentMaintenanceController() {
        let maintenanceController = maintenanceViewController()
        navigationController?.present(maintenanceController, animated: true, completion: nil)
    }

    static func presentContainerVolumeController(controller: ContainerVolumeViewController) {
        rootNavigationController?.topVisibleViewController.present(controller.embedInNavigationController(),
                                                                   animated: true,
                                                                   completion: nil)
    }

    static func animateBasketItem() {
        guard let mainController = NavigationService.mainViewController,
            let cartItem = mainController.tabBar.items?[2]
            else { return }
        if let view = cartItem.value(forKey: "view") as? UIView {
            view.layer.add(bounceAnimation, forKey: nil)
        }
    }

    private static var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 1.0]
        bounceAnimation.duration = TimeInterval(0.2)
        return bounceAnimation
    }()

}
