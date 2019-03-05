final class ChefsViewModel: BaseTableViewModel<[Chef], Chef> {

    private let chefsPlaceholders = [
        Chef(id: -1, email: "LOADING", name: "LOADING", dishes: nil),
        Chef(id: -1, email: "LOADING", name: "LOADING", dishes: nil),
        Chef(id: -1, email: "LOADING", name: "LOADING", dishes: nil),
        Chef(id: -1, email: "LOADING", name: "LOADING", dishes: nil),
        Chef(id: -1, email: "LOADING", name: "LOADING", dishes: nil)
    ]

    init() {
        let chefsRequest = NetworkService.shared.getAllChefs()
        super.init(dataSource: chefsRequest)
        placeholderElements = chefsPlaceholders
    }

}
