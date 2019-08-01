enum StuartContainer: String {

    case xsmall // 40 x 30 x 3 cm
    case small  // 60 x 40 x 26 cm
    case medium // 58 x 48 x 40 cm
    case large  // 62 x 54 x 49 cm
    case xlarge // 100 x 80 x 70 cm

    // The volume of each stuart container
    var containerVolume: Int {
        switch self {
        case .xsmall:
            return 3600
        case .small:
            return 62400
        case .medium:
            return 111360
        case .large:
            return 164052
        case .xlarge:
            return 560000
        }
    }

    static func getContainerFor(volume: Int) -> StuartContainer? {
        switch volume {
        case 0 ... xsmall.containerVolume:
            return xsmall
        case xsmall.containerVolume ... small.containerVolume:
            return small
        case small.containerVolume ... medium.containerVolume:
            return medium
        case medium.containerVolume ... large.containerVolume:
            return large
        case large.containerVolume ... xlarge.containerVolume:
            return xlarge
        default:
            return nil
        }
    }

}
