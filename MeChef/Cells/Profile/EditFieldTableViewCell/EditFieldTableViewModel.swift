struct EditFieldTableViewModel {

    let fieldValue: String?
    let placeholder: String
    let secureText: Bool
    let hideBottomLine: Bool

    init(fieldValue: String?,
         placeholder: String,
         secureText: Bool = false,
         hideBottomLine: Bool = true) {
        self.fieldValue = fieldValue
        self.placeholder = placeholder
        self.secureText = secureText
        self.hideBottomLine = hideBottomLine
    }

}
