import RxSwift
import Alamofire

extension NetworkService {

    func getDishWith(dishId: Int64) -> Single<Dish> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes/\(dishId)")

        return request(with: apiParameters)
    }

    func getAllDishes() -> Single<[Dish]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "dishes",
                                                 parameters: currentCityParameter)

        return (request(with: apiParameters) as Single<DishesResponse>)
            .map { $0.dishes }
    }

    func searchDish(query: String) -> Single<[Dish]> {
        let parameters = ["search": query] as Parameters
        let apiParameters = ApiRequestParameters(relativeUrl: "searchDish",
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

}
