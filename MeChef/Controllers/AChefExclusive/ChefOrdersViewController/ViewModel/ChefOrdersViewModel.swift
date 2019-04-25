import Foundation
import RxSwift
import SwiftDate

final class ChefOrdersViewModel: BaseStatefulViewModel<ChefOrdersViewModel.ResultType> {

    struct ResultType {
        let orders: [Order]
        let deliverySlots: [DeliverySlot]
    }

    private let disposeBag = DisposeBag()
    var chefId: Int64
    var chefSlots: [DeliverySlot] = []
    var today = DateInRegion().dateAt(.startOfDay)

    init(chefId: Int64) {
        self.chefId = chefId
        let ordersRequest = NetworkService.shared.getOrdersFor(chefId: chefId)
        let slotsRequest = NetworkService.shared.getDeliverySlotFor(chefId: chefId)

        let zippedRequest = Single.zip(ordersRequest, slotsRequest, resultSelector: {
            ResultType(orders: $0, deliverySlots: $1)
        })
        super.init(dataSource: zippedRequest)
    }

}

extension ChefOrdersViewModel {

    var weekdaysOrdered: [Int64] {
        let firstDay = today.weekdayOrdinal
        var tempWeekdays = DeliverySlot.weekdayTable.map { $0.key }.sorted(by: { $0 < $1 })
        let toMoveDays = tempWeekdays[0...firstDay - 2]
        tempWeekdays.removeSubrange(0...firstDay - 2)
        tempWeekdays.append(contentsOf: toMoveDays)
        return tempWeekdays
    }

    func elementTitleAt(_ indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            let dayDate = today.dateByAdding(indexPath.row, .day)
            return "\(dayDate.weekdayName(.short)) \(dayDate.day)"
        default:
            return DeliverySlot.hoursRangeWithIndex(indexPath.section)
        }
    }

    func isAvailableAt(_ indexPath: IndexPath) -> Bool {
        guard !isLoading
            else { return false }
        return result.deliverySlots.contains(where: { $0.weekdayId == (weekdaysOrdered[indexPath.row])
            && $0.hourId == (indexPath.section) })
    }

    var cellColorForWeekdays: UIColor {
        return .white
    }

    var textColorForWeekdays: UIColor {
        return .mainOrangeColor
    }

    var cellColorForHours: UIColor {
        return .white
    }

    func textColorForAvailability(_ available: Bool) -> UIColor {
        return available ? .darkGrayColor : .lightGrayColor
    }

    func createStuartJobWith(orderId: Int64, chefLocation: StuartLocation) -> Single<Order> {
        return NetworkService.shared.getOrderWith(orderId: orderId)
            .flatMap { order -> Single<Order> in
                guard order.stuartId == nil
                    else { return Single.just(order) }
                let dropOff = StuartLocation(address: order.deliveryAddress,
                                             comment: order.deliveryComment,
                                             contact: order.user.stuartContact,
                                             packageType: "small",
                                             packageDescription: "",
                                             clientReference: nil)
                let jobParameters = StuartJobParameters(pickupAt: nil /*order.deliveryDate*/,
                                                        pickups: [chefLocation],
                                                        dropoffs: [dropOff],
                                                        transportType: nil)
                return NetworkService.shared.createStuartJobWith(jobParameters)
                    .flatMap { stuartJob -> Single<Order> in
                        self.setStuartIdWith(orderId: orderId,
                                             stuartId: stuartJob.id)
                            .flatMap { _ -> Single<Order> in
                                self.changeOrderStatusWith(orderId: orderId,
                                                           state: .scheduled)
                            }
                    }
            }
    }

    func setStuartIdWith(orderId: Int64, stuartId: Int64) -> Single<Order> {
        return NetworkService.shared.setStuartIdFor(orderId: orderId, stuartId: stuartId)
    }

    func changeOrderStatusWith(orderId: Int64, state: OrderStates) -> Single<Order> {
        return NetworkService.shared.changeOrderStatusWith(orderId: orderId,
                                                           state: state.rawValue)
    }

}
