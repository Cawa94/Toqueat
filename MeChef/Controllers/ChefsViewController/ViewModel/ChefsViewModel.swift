final class ChefsViewModel: BaseTableViewModel<[Chef], Chef> {

    init() {
        let chefsRequest = NetworkService.shared.getAllChefs()
        super.init(dataSource: chefsRequest)
    }

}
