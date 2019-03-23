import Foundation

private extension String {

    static let stuartTokenKey = "stuart_token"

}

extension UserDefaults {

    var stuartToken: String? {
        get {
            return object(forKey: .stuartTokenKey) as? String
        }
        set {
            set(newValue, forKey: .stuartTokenKey)
        }
    }

}
