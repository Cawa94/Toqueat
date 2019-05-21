import RxSwift
import Alamofire
import Stripe

extension NetworkService: STPEphemeralKeyProvider {

    func createCustomerKey(withAPIVersion apiVersion: String,
                           completion: @escaping STPJSONResponseCompletionBlock) {
        let url = "\(NetworkService.baseUrl)ephemeral_key"
        Alamofire.request(url,
                          method: .post,
                          parameters: ["api_version": apiVersion],
                          headers: ApiRequestParameters.commonHeaders)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    func generatePaymentIntent(parameters: StripePaymentIntentParameters) -> Single<StripePaymentIntentResponse> {
        let body = StripePaymentIntentBody(paymentIntent: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "generate_payment_context",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func requestChefStripeId(parameters: StripeOauthParameters) -> Single<StripeOauthResponse> {
        let fullUrl = "https://connect.stripe.com/oauth/token"
        let urlEncoding = URLEncoding(destination: .methodDependent,
                                      arrayEncoding: .brackets,
                                      boolEncoding: .literal)
        let apiParameters = ApiRequestParameters(url: fullUrl,
                                                 method: .post,
                                                 parameters: parameters.toJSON(),
                                                 encoding: urlEncoding,
                                                 headers: nil)

        return request(with: apiParameters)
    }

}
