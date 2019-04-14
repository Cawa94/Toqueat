final class ProfileViewModel: BaseStatefulViewModel<User> {

    init() {
        let userInfoRequest = NetworkService.shared.getUserInfo()
        super.init(dataSource: userInfoRequest)
    }

}

extension ProfileViewModel {

    var baseUser: BaseUser {
        return BaseUser(lastname: result.lastname, email: result.email,
                        id: result.id, name: result.name)
    }

}
