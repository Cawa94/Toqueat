import UIKit

extension UIButton {

    @IBInspectable var localizedText: String? {
        get { return titleLabel?.text }
        set(value) { self.setTitle(value!.localized, for: .normal) }
    }

}
