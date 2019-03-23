import UIKit
import RxSwift
import MBProgressHUD

extension UIViewController {

    /// Return top visible controller even if we have inner UI(Navigation/TabBar)Controller's inside
    var topVisibleViewController: UIViewController {
        switch self {
        case let navController as UINavigationController:
            return navController.visibleViewController?.topVisibleViewController ?? navController
        case let tabController as UITabBarController:
            return tabController.selectedViewController?.topVisibleViewController ?? tabController
        default:
            return self.presentedViewController?.topVisibleViewController ?? self
        }
    }

    open class var xibName: String {
        return String(describing: self)
    }

    func embedInNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)

        navController.isNavigationBarHidden = true
        return navController
    }

    func presentAlertWith(title: String, message: String, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        } else {
            _ = actions.compactMap {
                alert.addAction($0)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }

    typealias GetErrorTextClosure = (Error) -> String?

    func hudOperationWithRetry<ResultType>(operationSingle: Single<ResultType>,
                                           getErrorClosure: GetErrorTextClosure? = { _ in "" },
                                           onSuccessClosure: ((ResultType) -> Void)?,
                                           disposeBag: DisposeBag) {

        let progressHud = MBProgressHUD.showAdded(to: AppDelegate.shared.appWindow, animated: true)

        operationSingle
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { result in
                progressHud.mode = .customView
                progressHud.customView = UIImageView(image: UIImage(named: "checked"))
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    progressHud.hide(animated: true)
                    onSuccessClosure?(result)
                }
            }, onError: { _ in
                progressHud.hide(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
