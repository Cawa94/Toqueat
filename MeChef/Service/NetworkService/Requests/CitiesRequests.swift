import RxSwift
import Alamofire

extension NetworkService {

    func getCityWith(cityId: Int64) -> Single<City> {
        let apiParameters = ApiRequestParameters(relativeUrl: "cities/\(cityId)")

        return request(with: apiParameters)
    }

    func getAllCities() -> Single<[City]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "cities")

        return (request(with: apiParameters) as Single<CitiesResponse>)
            .map { $0.cities }
    }

}
