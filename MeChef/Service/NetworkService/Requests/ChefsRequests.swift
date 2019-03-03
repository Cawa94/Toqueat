import RxSwift
import Alamofire

extension NetworkService {

    func getChefWith(chefId: Int64) -> Single<Chef> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/chefs/\(chefId)")

        return request(with: apiParameters)
    }

    func getAllChefs() -> Single<[Chef]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "/chefs")

        return (request(with: apiParameters) as Single<ChefsResponse>)
            .map { $0.chefs }
    }

}
