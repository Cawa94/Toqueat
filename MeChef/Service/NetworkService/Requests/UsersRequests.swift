import RxSwift
import Alamofire

extension NetworkService {

    func login(loginBody: LoginParameters) -> Single<UserSession> {
        let body = loginBody
        let apiParameters = ApiRequestParameters(relativeUrl: "login",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func register(registerParameters: RegisterParameters) -> Single<UserSession> {
        let body = RegistrationBody(user: registerParameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "signup",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func getUserInfo() -> Single<User> {
        let apiParameters = ApiRequestParameters(relativeUrl: "users/current")

        return request(with: apiParameters)
    }

}
