enum OrderStates: String {

    case waitingForConfirmation
    case scheduled
    case canceled

    static func getStateFrom(_ string: String) -> OrderStates {
        switch string {
        case "waiting for confirmation":
            return .waitingForConfirmation
        case "scheduled":
            return .scheduled
        case "canceled":
            return .canceled
        default:
            return .waitingForConfirmation
        }
    }

}
