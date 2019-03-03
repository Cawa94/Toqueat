import Alamofire

public enum RequestError: Error {
    case noConnection
    case network(error: Error)
    case invalidResponse(error: AFError)
    case mapping(error: Error, response: Any)
}
