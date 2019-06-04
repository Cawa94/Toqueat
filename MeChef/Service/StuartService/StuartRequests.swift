import RxSwift
import Alamofire

extension NetworkService {

    func getStuartToken() -> Single<String> {
        let parameters = ["client_id": StuartService.clientID,
                          "client_secret": StuartService.clientSecret,
                          "scope": "api",
                          "grant_type": "client_credentials"]
        let apiParameters = ApiRequestParameters(stuartUrl: "oauth/token",
                                                 method: .post,
                                                 parameters: parameters)

        return (request(with: apiParameters) as Single<StuartToken>)
            .map { $0.accessToken }
    }

    func createStuartJobWith(_ jobParameters: StuartJobParameters) -> Single<StuartJob> {
        let body = StuartJobBody(job: jobParameters)
        let apiParameters = ApiRequestParameters(stuartUrl: "v2/jobs",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func getStuartJobPriceWith(_ jobParameters: StuartJobParameters) -> Single<NSDecimalNumber> {
        let body = StuartJobBody(job: jobParameters)
        let apiParameters = ApiRequestParameters(stuartUrl: "v2/jobs/pricing",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return (request(with: apiParameters) as Single<StuartJobPrice>)
            .map { $0.amount }
    }

    func getStuartJobWith(_ jobId: Int64) -> Single<StuartJob> {
        let apiParameters = ApiRequestParameters(stuartUrl: "v2/jobs/\(jobId)")

        return request(with: apiParameters)
    }

    func cancelStuartJobWith(_ jobId: Int64) -> Single<SimpleResponse> {
        let apiParameters = ApiRequestParameters(stuartUrl: "v2/jobs/\(jobId)/cancel")

        return request(with: apiParameters)
    }

    func validateAddress(_ address: String, phone: String?) -> Single<BaseSuccessResponse> {
        let addressBody = ["address": address,
                           "type": "delivering",
                           "phone": phone]
        let apiParameters = ApiRequestParameters(stuartUrl: "v2/addresses/validate",
                                                 parameters: addressBody.toJSON())

        return request(with: apiParameters)
    }

}
