import Foundation

extension Chef {

    var stuartContact: StuartContact {
        return StuartContact(firstname: name,
                             lastname: "",
                             phone: nil,
                             email: email,
                             company: nil,
                             companyName: nil)
    }

    var stuartLocation: StuartLocation {
        return StuartLocation(address: address,
                              comment: apartment,
                              contact: stuartContact,
                              packageType: nil,
                              packageDescription: nil,
                              clientReference: nil)
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
