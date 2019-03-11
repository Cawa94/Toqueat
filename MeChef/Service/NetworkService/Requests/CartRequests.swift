import RxSwift
import Alamofire

extension NetworkService {

    func getCartWith(id: Int64) -> Single<Order> {
        let apiParameters = ApiRequestParameters(relativeUrl: "carts/\(id)")

        return request(with: apiParameters)
    }

    func createNewCartWith(userId: Int64) -> Single<Order> {
        let parameters = OrderParameters(userId: userId)
        let body = OrderRequestBody(order: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "carts",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

}
