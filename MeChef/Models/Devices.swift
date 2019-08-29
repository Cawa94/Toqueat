import DeviceKit

class Devices: NSObject {

    static let shared = Devices()
    static let current = Device()

    override private init() {}

}
