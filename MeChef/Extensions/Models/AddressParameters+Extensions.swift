import Foundation

extension AddressParameters {

    var streetWithNumber: String {
        return "\(street) \(number ?? "")"
    }

    func fullAddressWith(city: String) -> String {
        return "\(street) \(number ?? "") \(zipcode) \(city)"
    }

}
