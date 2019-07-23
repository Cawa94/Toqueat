import Foundation

extension User {

    var fullAddress: String {
        return "\(address.street) \(address.number ?? ""), \(address.zipcode) \(address.city.name)"
    }

    var stuartContact: StuartContact {
        return StuartContact(firstname: name,
                             lastname: lastname,
                             phone: phone,
                             email: email,
                             company: nil,
                             companyName: nil)
    }

    var stuartComment: String? {
        var comment: String?
        if let floor = address.floor {
            comment = "Planta: \(floor) "
        }
        if let door = address.apartment {
            comment = "\(comment ?? "")Puerta: \(door)"
        }
        return comment
    }

}
