import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainGrayColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainOrangeColor], for: .selected)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white

        if !SessionService.isChef {
            let chefsController = NavigationService.chefsTab()
            let dishesController = NavigationService.dishesTab()
            let cartController = NavigationService.cartTab()

            viewControllers = [ chefsController, dishesController, cartController ]
        } else if let chefId = SessionService.session?.chef?.id {
            let chefDishesController = NavigationService.chefDishesTab(chefId: chefId)
            let chefOrdersController = NavigationService.chefOrderTab(chefId: chefId)
            let chefProfileController = NavigationService.chefProfileTab(chefId: chefId)

            viewControllers = [ chefDishesController, chefOrdersController, chefProfileController ]
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item == tabBar.items?.last) && !SessionService.isLoggedIn {
            //NavigationService.makeLoginRootController()
        }
    }

}
