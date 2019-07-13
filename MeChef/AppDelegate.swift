import UIKit
import IQKeyboardManagerSwift
import RxSwift
import UserNotifications
import Stripe

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

        self.registerForPushNotifications()

        NetworkService.shared.getStuartToken()
            .subscribe(onSuccess: { token in
                debugPrint("STUART TOKEN => \(token)")
                StuartService.authToken = token
            })
            .disposed(by: disposeBag)

        STPPaymentConfiguration.shared().publishableKey = StripeService.publicKey
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.toqueat.iosapp"

        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsDeviceToken = NSData(data: deviceToken)
        debugPrint("NOTIFICATIONS TOKEN => \(nsDeviceToken)")

        let token = "\(nsDeviceToken)".replacingOccurrences(of: " ", with: "")
        uploadDeviceToken(token)
    }

    func uploadDeviceToken(_ token: String) {
        if let chefId = SessionService.session?.chef?.id {
            NetworkService.shared.updateChefDeviceToken(token, chefId: chefId)
                .subscribe().disposed(by: disposeBag)
        } else if let userId = SessionService.session?.user?.id {
            NetworkService.shared.updateUserDeviceToken(token, userId: userId)
                .subscribe().disposed(by: disposeBag)
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted
                else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
                else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            UNUserNotificationCenter.current().delegate = self
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler(.alert)
    }

}

extension AppDelegate {

    // This method handles opening native URLs (e.g., "your-app://")
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if stripeHandled {
            return true
        } else {
            // This was not a stripe url – do whatever url handling your app
            // normally does, if any.
        }
        return false
    }

    // This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                if stripeHandled {
                    return true
                } else {
                    // This was not a stripe url – do whatever url handling your app
                    // normally does, if any.
                }
            }
        }
        return true
    }

}
