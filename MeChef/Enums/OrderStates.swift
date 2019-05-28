enum OrderState: String {

    case waitingForConfirmation = "waiting for confirmation"
    case scheduled = "scheduled"
    case enRoute = "en route"
    case delivered = "delivered"
    case canceled = "canceled"

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

    static func getStateIndexFor(_ state: OrderState) -> Int {
        switch state {
        case .enRoute:
            return 0
        case .scheduled:
            return 1
        case .waitingForConfirmation:
            return 2
        case .delivered:
            return 3
        case .canceled:
            return 4
        }
    }

}
