import UIKit

extension UIApplication {

    static func attemptPhoneCallWithPrompt(to phoneNumber: String) {
        let characterSet = CharacterSet(charactersIn: "+0123456789")
        let cleanPhoneNumber = phoneNumber.components(separatedBy: characterSet.inverted).joined(separator: "")
        if let escapedPhoneNumber = cleanPhoneNumber.addingPercentEncoding(withAllowedCharacters: characterSet),
            let phonePrompt = URL(string: "telprompt://\(escapedPhoneNumber)"),

            shared.canOpenURL(phonePrompt) {
            shared.support.open(phonePrompt)
        }
    }

}
