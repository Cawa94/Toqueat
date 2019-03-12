import RxSwift
import Alamofire

extension NetworkService {

    func getOrderWith(id: Int64) -> Single<Order> {
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(id)")

        return request(with: apiParameters)
    }

    func createNewOrderWith(userId: Int64) -> Single<Order> {
        let body = OrderCreateParameters(userId: userId)
        let apiParameters = ApiRequestParameters(relativeUrl: "orders",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateOrderFor(_ userId: Int64, with products: [Int64], chefId: Int64) -> Single<Order> {
        let body = OrderUpdateParameters(dishes: products.map { LocalCartDish(id: $0) },
                                         chefId: chefId)
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(userId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

}
