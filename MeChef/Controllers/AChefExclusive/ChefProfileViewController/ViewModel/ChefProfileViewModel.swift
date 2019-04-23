final class ChefProfileViewModel: BaseStatefulViewModel<Chef> {

    init(chefId: Int64) {
        let userInfoRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: userInfoRequest)
    }

}

extension ChefProfileViewModel {

    var baseChef: BaseUser {
        return BaseUser(lastname: result.lastname, email: result.email,
                        id: result.id, name: result.name)
    }

}
