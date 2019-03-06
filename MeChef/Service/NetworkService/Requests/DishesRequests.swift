import RxSwift
import Alamofire

extension NetworkService {

    func getDishWith(id: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes/\(id)")

        return request(with: apiParameters)
    }

    func getAllDishes() -> Single<[Dish]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes",
                                                 parameters: currentCityParameter)

        return (request(with: apiParameters) as Single<DishesResponse>)
            .map { $0.dishes }
    }

}
