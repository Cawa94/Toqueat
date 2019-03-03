import RxSwift
import Alamofire

extension NetworkService {

    func getDishWith(dishId: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/dishes/\(dishId)")

        return request(with: apiParameters)
    }

    func getAllDishes() -> Single<[Dish]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/dishes")

        return (request(with: apiParameters) as Single<DishesResponse>)
            .map { $0.dishes }
    }

}
