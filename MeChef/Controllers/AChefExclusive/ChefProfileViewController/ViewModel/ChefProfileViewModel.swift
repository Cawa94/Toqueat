final class ChefProfileViewModel: BaseStatefulViewModel<Chef> {

    let chefId: Int64

    init(chefId: Int64) {
        self.chefId = chefId

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
