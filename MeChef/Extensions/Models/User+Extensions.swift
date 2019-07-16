import Foundation

extension User {

    var fullAddress: String {
        return "\(address), \(zipcode) \(city.name)"
    }

    var stuartContact: StuartContact {
        return StuartContact(firstname: name,
                             lastname: lastname,
                             phone: phone,
                             email: email,
                             company: nil,
                             companyName: nil)
    }

}
