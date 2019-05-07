import RxSwift
import Alamofire

extension NetworkService {

    func getChefWith(chefId: Int64) -> Single<Chef> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)")

        return request(with: apiParameters)
    }

    func getAllChefs() -> Single<[BaseChef]> {
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

    func getDeliverySlotBusyIdsFor(chefId: Int64) -> Single<[Int64]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/deliveryslots_busy")

        return (request(with: apiParameters) as Single<DeliverySlotsBusyResponse>)
            .map { $0.deliverySlotsIds }
    }

    func getOrdersFor(chefId: Int64) -> Single<[BaseOrder]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/orders")

        return (request(with: apiParameters) as Single<OrdersResponse>)
            .map { $0.orders }
    }

    func getWeekplanFor(chefId: Int64) -> Single<[BaseOrder]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)/weekplan")

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

    func searchChef(query: String) -> Single<[BaseChef]> {
        let parameters = ["search": query] as Parameters
        let apiParameters = ApiRequestParameters(relativeUrl: "searchChef",
                                                 parameters: parameters + currentCityParameter)

        return (request(with: apiParameters) as Single<ChefsResponse>)
            .map { $0.chefs }
    }

    func updateChefWith(parameters: ChefUpdateParameters, chefId: Int64) -> Single<Chef> {
        let body = ChefUpdateBody(chef: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateChefAddress(parameters: AddressUpdateParameters, chefId: Int64) -> Single<Chef> {
        let body = AddressUpdateBody(address: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(chefId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    // swiftlint:disable all
    func uploadChefAvatar(for chefId: Int64, imageData: Data, completion: @escaping (_ error: Error?) -> Void) {
        let relativeUrl = "chefs/\(chefId)/update_avatar"
        let fullUrl = URL(string: NetworkService.baseUrl + relativeUrl)!
        let request = NSMutableURLRequest(url: fullUrl)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(filePathKey: "chef_avatar", imageDataKey: imageData, boundary: boundary)

        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if data != nil {
                completion(nil)
            } else if let error = error {
                completion(error)
            }
        })

        task.resume()
    }

}
