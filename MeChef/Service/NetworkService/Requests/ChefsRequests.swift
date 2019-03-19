import RxSwift
import Alamofire

extension NetworkService {

    func getChefWith(chefId: Int64) -> Single<Chef> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)")

        return request(with: apiParameters)
    }

    func getAllChefs() -> Single<[Chef]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs",
                                                 parameters: currentCityParameter)

        return (request(with: apiParameters) as Single<ChefsResponse>)
            .map { $0.chefs }
    }

    func getDeliverySlotFor(chefId: Int64) -> Single<[DeliverySlot]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/deliveryslots")

        return (request(with: apiParameters) as Single<DeliverySlotsResponse>)
            .map { $0.deliverySlots }
    }

    func getOrdersFor(chefId: Int64) -> Single<[Order]> {
        let parameters = ["chef_id": chefId]
        let apiParameters = ApiRequestParameters(relativeUrl: "chefOrders",
                                                 parameters: parameters)

        return (request(with: apiParameters) as Single<OrdersResponse>)
            .map { $0.orders }
    }

}
