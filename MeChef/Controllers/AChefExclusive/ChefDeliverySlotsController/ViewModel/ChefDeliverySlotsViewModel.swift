import Foundation

final class ChefDeliverySlotsViewModel: BaseStatefulViewModel<Chef> {

    init(chefId: Int64) {
        let chefRequest = NetworkService.shared.getChefWith(chefId: chefId)
        super.init(dataSource: chefRequest)
    }

}

extension ChefDeliverySlotsViewModel {
    
}
