import UIKit

extension UILabel {

    @IBInspectable var localizedText: String? {
        get { return text }
        set(value) { text = value!.localized }
    }

}
