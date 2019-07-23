import Foundation

extension AddressParameters {

    var streetWithNumber: String {
        return "\(street) \(number ?? "")"
    }

}
