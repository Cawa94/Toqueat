struct UserBarTableViewModel {

    let option: String
    let arrowHidden: Bool
    let hideBottomLine: Bool
    let checkHidden: Bool

    init(option: String,
         arrowHidden: Bool = false,
         hideBottomLine: Bool = true,
         checkHidden: Bool = true) {
        self.option = option
        self.arrowHidden = arrowHidden
        self.hideBottomLine = hideBottomLine
        self.checkHidden = checkHidden
    }

}
