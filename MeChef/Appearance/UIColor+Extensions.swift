import UIKit

extension UIColor {

    //Gray
    static let mainGrayColor              = UIColor(hex6: 0x7B7878)
    static let darkGrayColor              = UIColor(hex6: 0x434343)
    static let lightGrayColor             = UIColor(hex6: 0xC1C1C1)
    static let placeholderGrayApple       = UIColor(hex6: 0xC7C7CD)
    static let placeholderPampasColor     = UIColor(hex6: 0xF3F0EB)
    static let lightGrayBackgroundColor   = UIColor(hex6: 0xFAFAFA)
    static let lightGrayBorderColor       = UIColor(hex6: 0xF0F0F0)
    static let weekdayBorderColor         = UIColor(hex6: 0xA5A5A5)

    //Orange
    static let mainOrangeColor         = UIColor(hex6: 0xF26E01)
    static let lightOrangeColor        = UIColor(hex6: 0xF29101)

}

private extension UIColor {

    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let red   = CGFloat((hex6 & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((hex6 & 0x00FF00) >>  8) / 0xFF
        let blue  = CGFloat((hex6 & 0x0000FF) >>  0) / 0xFF

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}
