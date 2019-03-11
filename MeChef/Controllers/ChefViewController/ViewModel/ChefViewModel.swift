import Foundation

final class ChefViewModel: BaseTableViewModel<Chef, Dish> {

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(id: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension ChefViewModel {

    var chefName: String {
        return isLoading ? "LOADING" : result.name
    }

    var cityName: String {
        return isLoading ? "LOADING" : result.city.name
    }

    var avatarUrl: URL? {
        if let avatarUrl = result.avatarUrl {
            return URL(string: "\(NetworkService.baseUrl)\(avatarUrl.dropFirst())")
        } else {
            return nil
        }
    }

}
