import Foundation

private extension String {

    static let localCartKey = "local_cart"

}

extension UserDefaults {

    var localCart: LocalCart? {
        get {
            return try? object(forKey: .localCartKey)
        }
        set {
            set(model: newValue, forKey: .localCartKey)
        }
    }

}
