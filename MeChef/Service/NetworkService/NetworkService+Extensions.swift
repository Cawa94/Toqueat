import RxSwift
import Alamofire
import ObjectMapper
import RxAlamofire

// Helper Methods
extension NetworkService {

    /// Perform reactive request to get mapped ImmutableMappable model and http response
    ///
    /// - Parameter parameters: api parameters to pass Alamofire
    /// - Returns: Observable of tuple containing (HTTPURLResponse, ImmutableMappable)
    public func rxRequest<T: ImmutableMappable>(with parameters: ApiRequestParameters)
        -> Observable<(response: HTTPURLResponse, model: T)> {
            return sessionManager.rx
                .responseModel(requestParameters: parameters,
                               acceptableStatusCodes: Alamofire.SessionManager.acceptableStatusCodes)
    }

}

private extension Reactive where Base: Alamofire.SessionManager {

    /// Method which executes request with given api parameters
    ///
    /// - Parameter requestParameters: api parameters to pass Alamofire
    /// - Returns: Observable with request
    func apiRequest(requestParameters: ApiRequestParameters,
                    acceptableStatusCodes: [Int] = Base.acceptableStatusCodes)
        -> Observable<DataRequest> {
            return request(requestParameters.method,
                           requestParameters.url,
                           parameters: requestParameters.parameters,
                           encoding: requestParameters.encoding,
                           headers: requestParameters.headers)
                .map { $0.validate(statusCode: acceptableStatusCodes) }
    }

    /// Method that executes request and serializes response into target object
    ///
    /// - Parameter requestParameters: api parameters to pass Alamofire
    /// - Parameter mappingQueue: The dispatch queue to use for mapping
    /// - Returns: Observable with HTTP URL Response and target object
    func responseModel<T: ImmutableMappable>(requestParameters: ApiRequestParameters,
                                             mappingQueue: DispatchQueue = .global(),
                                             acceptableStatusCodes: [Int] = Base.acceptableStatusCodes)
        -> Observable<(response: HTTPURLResponse, model: T)> {
            return apiRequest(requestParameters: requestParameters, acceptableStatusCodes: acceptableStatusCodes)
                .flatMap { $0.rx.apiResponse(mappingQueue: mappingQueue) }
    }

}

typealias ServerResponse = (response: HTTPURLResponse, result: Any)

private extension Reactive where Base: DataRequest {

    private typealias JSON = [String: Any]

    /// Method that serializes response into target object
    ///
    /// - Parameter mappingQueue: The dispatch queue to use for mapping
    /// - Returns: Observable with HTTP URL Response and target object
    func apiResponse<T: ImmutableMappable>(mappingQueue: DispatchQueue = .global())
        -> Observable<(response: HTTPURLResponse, model: T)> {
            return responseJSONOnQueue(mappingQueue)
                .tryMapResult { resp, value in
                    let json = try self.cast(value) as JSON
                    return (resp, try T(JSON: json))
            }
    }

    func responseJSONOnQueue(_ queue: DispatchQueue) -> Observable<ServerResponse> {
        let responseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        return responseResult(queue: queue, responseSerializer: responseSerializer)
            .map { ServerResponse(response: $0.0, result: $0.1) }
            .catchError {
                switch $0 {
                case let urlError as URLError:
                    switch urlError.code {
                    case .notConnectedToInternet, .timedOut:
                        throw RequestError.noConnection
                    default:
                        throw RequestError.network(error: urlError)
                    }
                case let afError as AFError:
                    switch afError {
                    case .responseSerializationFailed, .responseValidationFailed:
                        throw RequestError.invalidResponse(error: afError)
                    default:
                        throw RequestError.network(error: afError)
                    }
                default:
                    throw RequestError.network(error: $0)
                }
        }
    }

    func cast<T>(_ value: Any?) throws -> T {
        guard let val = value as? T else {
            throw LeadKitError.failedToCastValue(expectedType: T.self, givenType: type(of: value))
        }
        return val
    }

}

private extension ObservableType where E == ServerResponse {

    func tryMapResult<R>(_ transform: @escaping (E) throws -> R) -> Observable<R> {
        return map {
            do {
                return try transform($0)
            } catch {
                throw RequestError.mapping(error: error, response: $0.1)
            }
        }
    }

}

/// Protocol for concurrent model mapping
public protocol ObservableMappable {
    associatedtype ModelType
    static func createFrom(map: Map) -> Observable<ModelType>
}
