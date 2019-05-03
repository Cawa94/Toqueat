struct UserBarTableViewModel {

    let option: String
    let arrowHidden: Bool
    let hideBottomLine: Bool

    init(option: String,
         arrowHidden: Bool = false,
         hideBottomLine: Bool = true) {
        self.option = option
        self.arrowHidden = arrowHidden
        self.hideBottomLine = hideBottomLine
    }

}
