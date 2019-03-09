final class ChefsViewModel: BaseTableViewModel<[Chef], Chef> {

    private let chefsPlaceholders = [
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING"),
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING"),
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING"),
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING"),
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING"),
        Chef(email: "LOADING", dishes: nil, city: City(id: -1, name: ""), id: -1, name: "LOADING")
    ]

    init() {
        let chefsRequest = NetworkService.shared.getAllChefs()
        super.init(dataSource: chefsRequest)
        placeholderElements = chefsPlaceholders
    }

}
