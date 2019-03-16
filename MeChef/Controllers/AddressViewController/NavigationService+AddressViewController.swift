import UIKit

extension NavigationService {

    static func addressViewController(city: String) -> AddressViewController {
        let controller = AddressViewController(nibName: AddressViewController.xibName,
                                               bundle: nil)
        controller.setLocationFor(city: city)
        return controller
    }

}
