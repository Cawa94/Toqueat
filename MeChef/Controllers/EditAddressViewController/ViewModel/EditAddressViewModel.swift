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
        return isChef ? chef?.city.name : user?.city.name
    }

    var address: String? {
        return isChef ? chef?.address : user?.address
    }

    var apartment: String? {
        return isChef ? chef?.apartment : user?.apartment
    }

    var zipcode: String? {
        return isChef ? chef?.zipcode : user?.zipcode
    }

}
