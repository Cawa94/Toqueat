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
        let body = parameters
        let apiParameters = ApiRequestParameters(relativeUrl: "orders",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

}
