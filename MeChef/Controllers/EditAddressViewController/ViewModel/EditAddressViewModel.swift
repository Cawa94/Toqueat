final class EditAddressViewModel: BaseStatefulViewModel<[City]> {

    let user: User?
    let chef: Chef?

    init(user: User?, chef: Chef?) {
        self.user = user
        self.chef = chef

        let citiesRequest = NetworkService.shared.getAllCities()
        super.init(dataSource: citiesRequest)
    }

}

extension EditAddressViewModel {

    var isChef: Bool {
        return SessionService.isChef
    }

    var city: String? {
        return isChef ? chef?.address.city.name : user?.address.city.name
    }

    var street: String? {
        return isChef ? chef?.address.street : user?.address.street
    }

    var number: String? {
        return isChef ? chef?.address.number : user?.address.number
    }

    var floor: String? {
        return isChef ? chef?.address.floor : user?.address.floor
    }

    var apartment: String? {
        return isChef ? chef?.address.apartment : user?.address.apartment
    }

    var zipcode: String? {
        return isChef ? chef?.address.zipcode : user?.address.zipcode
    }

}
