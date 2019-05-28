enum TransportType: String {

    case bike
    case motorbike
    case car

    static func getTransportFrom(_ string: String) -> TransportType {
        switch string {
        case bike.rawValue:
            return .bike
        case motorbike.rawValue:
            return motorbike
        case car.rawValue:
            return car
        default:
            return bike
        }
    }

}
