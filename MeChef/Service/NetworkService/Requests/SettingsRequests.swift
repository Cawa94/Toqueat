import RxSwift
import Alamofire

extension NetworkService {

    func getAppSettings() -> Single<AppSettings> {
        let apiParameters = ApiRequestParameters(relativeUrl: "app_settings")

        return request(with: apiParameters)
    }

}
