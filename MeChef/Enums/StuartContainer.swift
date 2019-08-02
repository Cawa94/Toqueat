enum StuartContainer: String {

    case xsmall // 40 x 30 x 3 cm
    case small  // 60 x 40 x 26 cm
    case medium // 58 x 48 x 40 cm
    case large  // 62 x 54 x 49 cm
    case xlarge // 100 x 80 x 70 cm

    static let allValues = [xsmall, small, medium, large, xlarge]

    // The volume of each stuart container
    var volume: Int {
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

    // The width, height and depth of each stuart container
    var sizes: [Int] {
        switch self {
        case .xsmall:
            return [40, 30, 3]
        case .small:
            return [60, 40, 26]
        case .medium:
            return [58, 48, 40]
        case .large:
            return [62, 54, 49]
        case .xlarge:
            return [100, 80, 70]
        }
    }

    static func getMinimumContainerSizeFor(sizes: [Int]) -> StuartContainer? {
        var container: StuartContainer?
        let sortedSizes = sizes.sorted(by: { $0 > $1 })
        var valid = false
        for value in allValues.sorted(by: { $0.volume < $1.volume }) where !valid {
            for size in value.sizes.enumerated().sorted(by: { $0 > $1 }) {
                valid = sortedSizes[size.offset] < size.element
                if !valid {
                    break
                }
            }
            if valid {
                container = value
            }
        }
        return container
    }

    static func getContainerFor(volume: Int,
                                minContainer: StuartContainer?) -> StuartContainer? {
        var container: StuartContainer
        switch volume {
        case 0 ... xsmall.volume:
            container = xsmall
        case xsmall.volume ... small.volume:
            container = small
        case small.volume ... medium.volume:
            container = medium
        case medium.volume ... large.volume:
            container = large
        case large.volume ... xlarge.volume:
            container = xlarge
        default:
            return nil
        }

        // check if container obtained with volume is smaller than minimum container required
        if let minContainer = minContainer, container.volume < minContainer.volume {
            container = minContainer
        }
        debugPrint("STUART CONTAINER: \(container)")
        return container
    }

    static func getContainerFrom(_ string: String) -> StuartContainer? {
        switch string {
        case "xsmall":
            return .xsmall
        case "small":
            return .small
        case "medium":
            return .medium
        case "large":
            return .large
        case "xlarge":
            return .xlarge
        default:
            return nil
        }
    }

}
