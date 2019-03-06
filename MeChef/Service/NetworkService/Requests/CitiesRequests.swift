import RxSwift
import Alamofire

extension NetworkService {

    func getCityWith(id: Int64) -> Single<City> {
        let apiParameters = ApiRequestParameters(relativeUrl: "cities/\(id)")

        return request(with: apiParameters)
    }

    func getAllCities() -> Single<[City]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "cities")

        return (request(with: apiParameters) as Single<CitiesResponse>)
            .map { $0.cities }
    }

}
