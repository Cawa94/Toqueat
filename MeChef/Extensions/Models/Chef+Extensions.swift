import Foundation

extension Chef {

    var stuartContact: StuartContact {
        return StuartContact(firstname: name,
                             lastname: lastname,
                             phone: phone,
                             email: email,
                             company: nil,
                             companyName: nil)
    }

    var stuartLocation: StuartLocation {
        return StuartLocation(address: "\(address.street) \(address.number ?? "")",
                              comment: stuartComment,
                              contact: stuartContact,
                              packageType: nil,
                              packageDescription: nil,
                              clientReference: nil)
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

extension BaseChef {

    var avatarLink: URL? {
        if let avatarUrl = avatarUrl {
            return URL(string: "\(NetworkService.baseUrl)\(avatarUrl.dropFirst())")
        } else {
            return nil
        }
    }

}
