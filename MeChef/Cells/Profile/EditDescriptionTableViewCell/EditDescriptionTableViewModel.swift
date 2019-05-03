struct EditDescriptionTableViewModel {

    let fieldValue: String?
    let placeholder: String
    let hideBottomLine: Bool

    init(fieldValue: String?,
         placeholder: String,
         hideBottomLine: Bool = true) {
        self.fieldValue = fieldValue
        self.placeholder = placeholder
        self.hideBottomLine = hideBottomLine
    }

}
