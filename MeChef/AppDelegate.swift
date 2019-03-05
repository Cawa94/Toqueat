import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var appWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return window
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
        // Override point for customization after application launch.
            NavigationService.setRootController(controller: NavigationService.mainTabViewController())
        return true
    }

}
