import UIKit

extension UIFont {

    static func regularFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "HelveticaNeue", size: size)
    }

    static func semiBoldFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "HelveticaNeue-Medium", size: size)
    }

    static func boldFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "HelveticaNeue-Bold", size: size)
    }

    private static func fontWith(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size)
            .unwrap(failureDescription: "Can't load font with name: \(name). Check bundle and .plist file.")
    }

}

private extension Optional {

    func unwrap(failureDescription: String) -> Wrapped {
        guard let unwrapped = self else {
            fatalError(failureDescription)
        }

        return unwrapped
    }

}
