import RxSwift
import RxCocoa
import Stripe

struct MainTabViewModel {}

extension MainTabViewModel {

    func getCustomerEphemeralKey() {
        if SessionService.isLoggedIn && !SessionService.isChef {
            NetworkService.shared.createCustomerKey(
                withAPIVersion: StripeService.apiVersion,
                completion: { _, _ in
                    StripeService.setCustomerContext()
            })
        }
    }

    func customizeStripeUI() {
        STPTheme.default().accentColor = .mainOrangeColor
        STPTheme.default().primaryBackgroundColor = .lightGrayBackgroundColor
        STPTheme.default().primaryForegroundColor = .darkGrayColor
        STPTheme.default().font = .regularFontOf(size: 15)
    }

}
