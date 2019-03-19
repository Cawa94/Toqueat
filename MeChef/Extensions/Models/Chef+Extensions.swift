import Foundation

extension Chef {

    var avatarLink: URL? {
        if let avatarUrl = avatarUrl {
            return URL(string: "\(NetworkService.baseUrl)\(avatarUrl.dropFirst())")
        } else {
            return nil
        }
    }

}
