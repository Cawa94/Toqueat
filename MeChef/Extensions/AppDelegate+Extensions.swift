import UIKit

extension AppDelegate {

    static var shared: AppDelegate {
        let delegate = UIApplication.shared.delegate

        guard let appDelegate = delegate as? AppDelegate else {
            /*ABNotifier.logError(["errorReason": "Cannot cast \(type(of: delegate)) to AppDelegate",
                "errorName": "Fatal Error"])*/
            fatalError("Cannot cast \(type(of: delegate)) to AppDelegate")
        }

        return appDelegate
    }

}
