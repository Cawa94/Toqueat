import Foundation.NSAttributedString
import UIKit

enum RoundedButtonType {

    case defaultOrange
    case squeezedOrange
    case squeezedWhite

}

struct RoundedButtonViewModel {

    let attributedTitle: NSAttributedString
    let type: RoundedButtonType
    let loadingState: Bool

}

extension RoundedButtonViewModel {

    init(title: String, type: RoundedButtonType, loadingState: Bool = false) {
        let attributedTitle = NSAttributedString(string: title, attributes: type.atrributedStringAttributes)
        self.init(attributedTitle: attributedTitle, type: type, loadingState: loadingState)
    }

}

extension RoundedButtonType {

    var atrributedStringAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .defaultOrange:
            return [
                .foregroundColor: UIColor.white,
                .font: UIFont.mediumFontOf(size: 18)
            ]
        case .squeezedOrange:
            return [
                .foregroundColor: UIColor.white,
                .font: UIFont.mediumFontOf(size: 18)
            ]
        case .squeezedWhite:
            return [
                .foregroundColor: UIColor.mainOrangeColor,
                .font: UIFont.mediumFontOf(size: 18)
            ]
        }
    }

}
