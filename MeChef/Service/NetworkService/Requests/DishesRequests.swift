import LeadKit
import RxSwift
import LeadKitAdditions
import Alamofire
import RxAlamofire

enum ProfileError: Error {
    case unableToUploadAvatar
}

extension NetworkService {

    func getDishWith(dishId: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes/\(dishId)")

        return request(with: apiParameters)
    }

    func getAllDishes() -> Single<[BaseDish]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes",
                                                 parameters: currentCityParameter)

        return (request(with: apiParameters) as Single<DishesResponse>)
            .map { $0.dishes }
    }

    func searchDish(query: String?, categoryId: Int64?) -> Single<[BaseDish]> {
        var parameters: Parameters = [:]
        if let categoryId = categoryId, let query = query {
            parameters = ["search_query": query,
                          "category_id": categoryId]
        } else if let query = query {
            parameters = ["search_query": query]
        } else if let categoryId = categoryId {
            parameters = ["category_id": categoryId]
        }
        let apiParameters = ApiRequestParameters(relativeUrl: "search_dish",
                                                 parameters: parameters + currentCityParameter)

        return (request(with: apiParameters) as Single<DishesResponse>)
            .map { $0.dishes }
    }

    func createNewDishWith(parameters: DishCreateParameters) -> Single<Dish> {
        let body = DishBody(dish: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateDishWith(parameters: DishCreateParameters, dishId: Int64) -> Single<Dish> {
        let body = DishBody(dish: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes/\(dishId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func toggleDishAvailability(dishId: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes/\(dishId)/toggle_availability",
                                                 method: .post)

        return request(with: apiParameters)
    }

    // swiftlint:disable all
    func uploadDishPicture(for dishId: Int64, imageData: Data, completion: @escaping (_ error: Error?) -> Void) {
        let relativeUrl = "dishes/\(dishId)/update_image"
        let fullUrl = URL(string: NetworkService.baseUrl + relativeUrl)!
        let request = NSMutableURLRequest(url: fullUrl)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(filePathKey: "dish_image", imageDataKey: imageData, boundary: boundary)

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

    func createBodyWithParameters(filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        let filename = "image.jpg"
        let mimetype = "image/jpg"

        body.append(NSString(format: "--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey)
        body.append(NSString(format: "\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        return body as Data
    }

}
