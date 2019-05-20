import RxSwift
import Alamofire

extension NetworkService {

    func login(loginBody: LoginParameters) -> Single<LoginResponse> {
        let body = loginBody
        let apiParameters = ApiRequestParameters(relativeUrl: "login",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func register(registerParameters: UserCreateParameters) -> Single<LoginResponse> {
        let body = UserCreateBody(user: registerParameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "signup",
                                                 method: .post,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateUserWith(parameters: UserUpdateParameters, userId: Int64) -> Single<User> {
        let body = UserUpdateBody(user: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "users/\(userId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func updateUserAddress(parameters: AddressUpdateParameters, userId: Int64) -> Single<User> {
        let body = AddressUpdateBody(address: parameters)
        let apiParameters = ApiRequestParameters(relativeUrl: "users/\(userId)",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

    func getUserInfo() -> Single<User> {
        let apiParameters = ApiRequestParameters(relativeUrl: "users/current")

        return request(with: apiParameters)
    }

    func getOrdersFor(userId: Int64) -> Single<[BaseOrder]> {
        let apiParameters = ApiRequestParameters(relativeUrl: "users/\(userId)/orders")

        return (request(with: apiParameters) as Single<OrdersResponse>)
            .map { $0.orders }
    }

    func updateUserDeviceToken(_ token: String, userId: Int64) -> Single<User> {
        let body = [
            "device_token": token
        ]

        let apiParameters = ApiRequestParameters(relativeUrl: "users/\(userId)/update_device_token",
                                                 method: .patch,
                                                 parameters: body.toJSON())

        return request(with: apiParameters)
    }

}
