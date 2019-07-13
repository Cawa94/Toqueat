final class RegisterViewModel: BaseStatefulViewModel<[City]> {

    let asChef: Bool

    init(asChef: Bool) {
        self.asChef = asChef

        let citiesRequest = NetworkService.shared.getAllCities()
        super.init(dataSource: citiesRequest)
    }

    var cities: [City] = []

}
