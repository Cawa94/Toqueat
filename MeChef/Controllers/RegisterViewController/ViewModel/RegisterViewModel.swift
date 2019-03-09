final class RegisterViewModel: BaseStatefulViewModel<[City]> {

    init() {
        let citiesRequest = NetworkService.shared.getAllCities()
        super.init(dataSource: citiesRequest)
    }

    var cities: [City] = []

}
