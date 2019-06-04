import Foundation
import RxSwift
import SwiftDate

struct OrderDetailsViewModel {

    let order: Order?
    let stuartJob: StuartJob?
    let driverPhone: String?
    let isLoading: Bool
    let deliveryInProgress: Bool

}

extension OrderDetailsViewModel {

    func quantityOf(dish: LocalCartDish) -> Int {
        return order?.dishes.filter { $0.id == dish.id }.count ?? 1
    }

    var stuartDriver: StuartDriver? {
        return stuartJob?.driver
    }

    func numberOfItems(for section: Int) -> Int {
        return isLoading ? 4 : elements.count
    }

    var elements: [LocalCartDish] {
        return order?.dishes.map { $0.asLocalCartDish }.uniqueElements ?? []
    }

}
