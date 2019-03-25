import Foundation

extension BaseUser {

    var stuartContact: StuartContact {
        return StuartContact(firstname: name,
                             lastname: lastname,
                             phone: nil,
                             email: email,
                             company: nil,
                             companyName: nil)
    }

}
