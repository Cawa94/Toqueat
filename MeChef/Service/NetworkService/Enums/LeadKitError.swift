import Alamofire

public enum LeadKitError: Error {
    case failedToCastValue(expectedType: Any.Type, givenType: Any.Type)
}
