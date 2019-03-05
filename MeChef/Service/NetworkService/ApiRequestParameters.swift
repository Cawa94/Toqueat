import Alamofire

/**
 *  Struct which keeps base parameters required for api request
 */
public struct ApiRequestParameters {

    let method: HTTPMethod
    let url: URLConvertible
    let parameters: Parameters?
    let encoding: ParameterEncoding
    let headers: HTTPHeaders?

    public init(url: URLConvertible,
                method: HTTPMethod = .get,
                parameters: Parameters? = nil,
                encoding: ParameterEncoding = URLEncoding.default,
                headers: HTTPHeaders? = nil) {

        self.method = method
        self.url = url
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }

    static var commonHeaders: HTTPHeaders {
        if let authToken = SessionService.user?.authToken {
            return ["Authorization": authToken]
        } else {
            return [:]
        }
    }

    init(relativeUrl: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
        let fullUrl = NetworkService.baseUrl + relativeUrl
        self.init(url: fullUrl,
                  method: method,
                  parameters: parameters,
                  encoding: URLEncoding.default,
                  headers: ApiRequestParameters.commonHeaders)
    }

}
