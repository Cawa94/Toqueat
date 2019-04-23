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
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/orders")

        return (request(with: apiParameters) as Single<OrdersResponse>)
            .map { $0.orders }
    }

    func updateDeliverySlotsFor(chefId: Int64, slots: [Int64]) -> Single<[DeliverySlot]> {
        let body = ChefUpdateDeliverySlots(deliverySlotIds: slots)
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/update_deliveryslots",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return (request(with: apiParameters) as Single<DeliverySlotsResponse>)
            .map { $0.deliverySlots }
    }

    func searchChef(query: String) -> Single<[Chef]> {
        let parameters = ["search": query] as Parameters
        let apiParameters = ApiRequestParameters(relativeUrl: "searchChef",
                                                 parameters: parameters + currentCityParameter)

        return (request(with: apiParameters) as Single<ChefsResponse>)
            .map { $0.chefs }
    }

}
