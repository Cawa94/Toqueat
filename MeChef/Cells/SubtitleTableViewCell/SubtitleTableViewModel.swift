import Foundation

struct SubtitleTableViewModel {

    let title: String
    let value: String?
    let attributedValue: NSAttributedString?

    init(title: String,
         value: String? = nil,
         attributedValue: NSAttributedString? = nil) {
        self.title = title
        self.value = value
        self.attributedValue = attributedValue
    }

}
