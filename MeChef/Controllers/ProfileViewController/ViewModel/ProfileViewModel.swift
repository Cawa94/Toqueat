final class ProfileViewModel: BaseStatefulViewModel<User> {

    init() {
        let userInfoRequest = NetworkService.shared.getUserInfo()
        super.init(dataSource: userInfoRequest)
    }

}

extension ProfileViewModel {

    var name: String {
        return result.name
    }

    var lastname: String {
        return result.lastname
    }

    var email: String {
        return result.email
    }

    var address: String {
        return result.address
    }

    var zipcode: String {
        return result.zipcode
    }

    var city: String {
        return result.city.name
    }

}
