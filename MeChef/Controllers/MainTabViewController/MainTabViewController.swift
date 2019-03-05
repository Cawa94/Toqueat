import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainGrayColor], for: .normal)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white

        let dishesController = NavigationService.dishesViewController().embedInNavigationController()
        dishesController.tabBarItem =
            UITabBarItem(title: "Dishes",
                         image: UIImage(named: "dish_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "dish_icon_on")?.withRenderingMode(.alwaysOriginal))

        let chefsController = NavigationService.chefsViewController().embedInNavigationController()
        chefsController.tabBarItem =
            UITabBarItem(title: "Chefs",
                         image: UIImage(named: "chef_icon_off")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "chef_icon_on")?.withRenderingMode(.alwaysOriginal))

        let profileController = NavigationService.loginOrProfileTab().embedInNavigationController()

        let viewControllerList = [ dishesController, chefsController, profileController ]
        viewControllers = viewControllerList
    }

}
