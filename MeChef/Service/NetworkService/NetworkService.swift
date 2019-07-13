import RxSwift
import Alamofire
import ObjectMapper
import Stripe

public extension Alamofire.SessionManager {

    /// The default acceptable range 200...299
    static let acceptableStatusCodes = Array(200..<499)

}

class NetworkService: NSObject {

    static let baseUrl = "https://toqueat.com/" // Server
    //static let baseUrl = "http://192.168.1.33:3000/" // Home
    //static let baseUrl = "http://192.168.2.177:3000/" // Office

    // Alamofire Settings
    var defaultTimeoutInterval: TimeInterval = 20.0
    var serverTrustPolicies: [String: ServerTrustPolicy] = [:]
    var sessionManager: SessionManager!

    static let shared = NetworkService()

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = defaultTimeoutInterval

        sessionManager =
            SessionManager(configuration: configuration,
                           serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }

    var currentCityParameter: Parameters {
        guard let userCityId = SessionService.session?.user?.city.id
            else { return [:] }
        return ["city_id": userCityId]
    }

    func request<T: ImmutableMappable>(with parameters: ApiRequestParameters) -> Single<T> {
        let apiResponseRequest = rxRequest(with: parameters) as Observable<(response: HTTPURLResponse, model: T)>
        return apiResponseRequest
            .map {
                $0.model
            }
            .do(onError: { error in
                debugPrint(parameters.url)
                debugPrint(error)
                let message: String
                if let stuartError = error.stuartError {
                    message = stuartError.message
                } else if let serverError = error.serverError,
                    let title = serverError.error {
                    message = title
                } else {
                    message = .errorSomethingWentWrong()
                }
                DispatchQueue.main.async {
                    NavigationService.topControllerPresentAlertWith(title: String.commonWarning().capitalized,
                                                                    message: message)
                }
            })
            .asSingle()
    }

}
