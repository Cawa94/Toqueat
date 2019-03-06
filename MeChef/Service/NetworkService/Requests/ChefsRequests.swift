import RxSwift
import Alamofire

extension NetworkService {

    func getChefWith(id: Int64) -> Single<Chef> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs/\(id)")

        return request(with: apiParameters)
    }

    func getAllChefs() -> Single<[Chef]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "chefs",
                                                 parameters: currentCityParameter)

        return (request(with: apiParameters) as Single<ChefsResponse>)
            .map { $0.chefs }
    }

}
