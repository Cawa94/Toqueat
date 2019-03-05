final class ProfileViewModel: BaseStatefulViewModel<User> {

    init() {
        let userInfoRequest = NetworkService.shared.getUserInfo()
        super.init(dataSource: userInfoRequest)
    }

}
