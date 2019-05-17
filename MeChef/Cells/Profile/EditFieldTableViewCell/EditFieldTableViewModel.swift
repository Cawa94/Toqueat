struct EditFieldTableViewModel {

    let fieldValue: String?
    let placeholder: String
    let fieldCapitalized: Bool
    let hideBottomLine: Bool
    let pickerValues: [String]

    init(fieldValue: String?,
         placeholder: String,
         fieldCapitalized: Bool = true,
         hideBottomLine: Bool = true,
         pickerValues: [String] = []) {
        self.fieldValue = fieldValue
        self.placeholder = placeholder
        self.fieldCapitalized = fieldCapitalized
        self.hideBottomLine = hideBottomLine
        self.pickerValues = pickerValues
    }

}
