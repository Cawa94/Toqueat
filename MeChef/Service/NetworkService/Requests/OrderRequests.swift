import RxSwift
import Alamofire

extension NetworkService {

    func getOrderWith(orderId: Int64) -> Single<Order> {
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)")

        return request(with: apiParameters)
    }

    func getUserLastOrder() -> Single<Order> {
        let apiParameters = ApiRequestParameters(relativeUrl: "lastOrder")

        return request(with: apiParameters)
    }

    func createNewOrderWith(parameters: OrderCreateParameters) -> Single<Order> {
        let body = OrderBody(order: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "orders",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func getOrderDriverLocation(orderId: Int64) -> Single<OrderDriver> {
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)/driver_location",
                                                 method: .get)

        return request(with: apiParameters)
    }

    func changeOrderStatusWith(orderId: Int64, state: OrderState) -> Single<Order> {
        let parameters = ["state": state.rawValue]
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)/set_new_state",
                                                 method: .patch,
                                                 parameters: parameters)

        return request(with: apiParameters)
    }

    func setStuartIdFor(orderId: Int64, stuartId: Int64) -> Single<Order> {
        let parameters = ["stuart_id": stuartId]
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)/set_stuart_id",
                                                 method: .patch,
                                                 parameters: parameters)

        return request(with: apiParameters)
    }

    func getDeliveryCost(pickupAt: Date?,
                         userAddress: String,
                         userComment: String?,
                         chef: Chef,
                         orderVolume: Int) -> Single<NSDecimalNumber> {
        let pickup = chef.stuartLocation
        let dropOff = StuartLocation(address: userAddress,
                                     comment: userComment,
                                     contact: nil,
                                     packageType: StuartContainer.getContainerFor(volume: orderVolume)?.rawValue,
                                     packageDescription: "",
                                     clientReference: nil)
        let fixedStuartDate = pickupAt?.dateByAdding(-4, .hour).date
        let jobParameters = StuartJobParameters(pickupAt: fixedStuartDate,
                                                pickups: [pickup],
                                                dropoffs: [dropOff],
                                                transportType: nil)
        return NetworkService.shared.getStuartJobPriceWith(jobParameters)
    }

}
