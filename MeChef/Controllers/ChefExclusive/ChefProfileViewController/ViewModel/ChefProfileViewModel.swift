final class ChefProfileViewModel: BaseStatefulViewModel<Chef> {

    init(chefId: Int64) {
        let userInfoRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: userInfoRequest)
    }

}

extension ChefProfileViewModel {

    var name: String {
        return result.name
    }

    var lastname: String {
        return "" //result.lastname
    }

    var email: String {
        return result.email
    }

    var address: String {
        return "" //result.address
    }

    var zipcode: String {
        return "" //result.zipcode
    }

    var city: String {
        return result.city.name
    }

}
