import RxSwift
import Alamofire

extension NetworkService {

    func getCartWith(id: Int64) -> Single<Cart> {
        let apiParameters = ApiRequestParameters(relativeUrl: "carts/\(id)")

        return request(with: apiParameters)
    }

    func createNewCartWith(userId: Int64) -> Single<Cart> {
        let parameters = CartParameters(userId: userId)
        let body = CartRequestBody(cart: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "carts",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

}
