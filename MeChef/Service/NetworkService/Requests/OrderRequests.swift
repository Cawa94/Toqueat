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

    func changeOrderStatusWith(orderId: Int64, state: String) -> Single<Order> {
        let parameters = ["state": state]
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
                         chef: Chef) -> Single<NSDecimalNumber> {
        let pickup = chef.stuartLocation
        let dropOff = StuartLocation(address: userAddress,
                                     comment: userComment,
                                     contact: nil,
                                     packageType: "small",
                                     packageDescription: "",
                                     clientReference: nil)
        let jobParameters = StuartJobParameters(pickupAt: pickupAt,
                                                pickups: [pickup],
                                                dropoffs: [dropOff],
                                                transportType: nil)
        return NetworkService.shared.getStuartJobPriceWith(jobParameters)
    }

}
