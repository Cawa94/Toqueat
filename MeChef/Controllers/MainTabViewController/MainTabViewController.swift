import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainGrayColor], for: .normal)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white

        let dishesController = NavigationService.dishesControllerTab()

        let chefsController = NavigationService.chefsControllerTab()

        let profileController = NavigationService.loginOrProfileTab()

        let viewControllerList = [ dishesController, chefsController, profileController ]
        viewControllers = viewControllerList
    }

    func reloadDishesChefsControllers() {
        viewControllers?[0] = NavigationService.dishesControllerTab()
        viewControllers?[1] = NavigationService.chefsControllerTab()
    }

    func reloadProfileController() {
        viewControllers?[2] = NavigationService.loginOrProfileTab()
    }

}
