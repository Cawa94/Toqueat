import UIKit
import IQKeyboardManagerSwift
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let disposeBag = DisposeBag()
    var window: UIWindow?

    lazy var appWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return window
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NavigationService.setRootController(controller:
            NavigationService.mainTabViewController().embedInNavigationController())
        IQKeyboardManager.shared.enable = true

        NetworkService.shared.getStuartToken()
            .subscribe(onSuccess: { token in
                debugPrint("STUART TOKEN => \(token)")
                StuartService.authToken = token
            })
            .disposed(by: disposeBag)
        return true
    }

}
