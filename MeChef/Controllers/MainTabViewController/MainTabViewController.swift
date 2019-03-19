import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainGrayColor], for: .normal)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white

        if !SessionService.isChef {
            let dishesController = NavigationService.dishesTab()
            let chefsController = NavigationService.chefsTab()
            let profileController = NavigationService.profileOrEmptyTab()

            let viewControllerList = [ dishesController, chefsController, profileController ]
            viewControllers = viewControllerList
        } else if let chefId = SessionService.session?.chef?.id {
            let chefDishesController = NavigationService.chefDishesTab(chefId: chefId)
            let chefOrdersController = NavigationService.chefOrderTab(chefId: chefId)
            let chefProfileController = NavigationService.chefProfileTab(chefId: chefId)

            let viewControllerList = [ chefDishesController, chefOrdersController, chefProfileController ]
            viewControllers = viewControllerList
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item == tabBar.items?.last) && !SessionService.isLoggedIn {
            NavigationService.makeLoginRootController()
        }
    }

}
