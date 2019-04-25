enum OrderState: String {

    case waitingForConfirmation
    case scheduled
    case enRoute
    case delivered
    case canceled

    static func getStateFrom(_ string: String) -> OrderState {
        switch string {
        case "waiting for confirmation":
            return .waitingForConfirmation
        case "scheduled":
            return .scheduled
        case "en route":
            return .enRoute
        case "delivered":
            return .delivered
        case "canceled":
            return .canceled
        default:
            return .waitingForConfirmation
        }
    }

}
