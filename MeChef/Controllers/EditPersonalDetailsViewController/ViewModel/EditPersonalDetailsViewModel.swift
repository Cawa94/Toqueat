struct EditPersonalDetailsViewModel {

    let user: User?
    let chef: Chef?

}

extension EditPersonalDetailsViewModel {

    var isChef: Bool {
        return SessionService.isChef
    }

    var name: String? {
        return isChef ? chef?.name : user?.name
    }

    var lastname: String? {
        return isChef ? chef?.lastname : user?.lastname
    }

    var email: String? {
        return isChef ? chef?.email : user?.email
    }

    var phone: String? {
        return isChef ? chef?.phone : user?.phone
    }

}
