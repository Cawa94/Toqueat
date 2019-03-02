import RxSwift
import Alamofire
import ObjectMapper

public extension Alamofire.SessionManager {

    /// The default acceptable range 200...299
    static let acceptableStatusCodes = Array(200..<300)

}

class NetworkService {

    static let baseUrl = "http://192.168.1.36:3000" //"http://api.mechef.com:3000"

    // Alamofire Settings
    var defaultTimeoutInterval: TimeInterval = 20.0
    var serverTrustPolicies: [String: ServerTrustPolicy] = [baseUrl: .disableEvaluation]
    var sessionManager: SessionManager!

    static let shared = NetworkService()

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = defaultTimeoutInterval

        sessionManager =
            SessionManager(configuration: configuration,
                           serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }

    func request<T: ImmutableMappable>(with parameters: ApiRequestParameters) -> Single<T> {
        let apiResponseRequest = rxRequest(with: parameters) as Observable<(response: HTTPURLResponse, model: T)>
        return apiResponseRequest
            .map {
                $0.model
            }
            .do(onError: { error in
                debugPrint(error)
            })
            .asSingle()
    }

}
