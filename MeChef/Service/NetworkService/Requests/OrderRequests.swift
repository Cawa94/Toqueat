import RxSwift
import Alamofire

extension NetworkService {

    func getOrderWith(orderId: Int64) -> Single<Order> {
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)")

        return request(with: apiParameters)
    }

    func createNewOrderWith(userId: Int64) -> Single<Order> {
        let body = OrderCreateParameters(userId: userId)
        let apiParameters = ApiRequestParameters(relativeUrl: "orders",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateOrder(_ orderId: Int64, with products: [Int64], chefId: Int64) -> Single<Order> {
        let body = OrderUpdateParameters(dishes: products.map { LocalCartDish(id: $0) },
                                         chefId: chefId)
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateOrder(_ orderId: Int64, slotId: Int64) -> Single<Order> {
        let body = ["delivery_slot_id": slotId]
        let apiParameters = ApiRequestParameters(relativeUrl: "orders/\(orderId)",
            method: .patch,
            parameters: body.toJSON())
        
        return request(with: apiParameters)
    }

}
