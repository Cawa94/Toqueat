import RxSwift
import Alamofire

extension NetworkService {

    func getDishWith(dishId: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/dishes/\(dishId)")

        return request(with: apiParameters)
    }

    func getAllDishes() -> Single<DishesResponse> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/dishes")

        return request(with: apiParameters)
    }

    func getChefWith(chefId: Int64) -> Single<Chef> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/chefs/\(chefId)")

        return request(with: apiParameters)
    }

    func getAllChefs() -> Single<ChefsResponse> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/chefs")

        return request(with: apiParameters)
    }

}
