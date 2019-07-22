struct StuartService {

//#if DEBUG
    // Sandbox
    static let clientID = "c4f03fbdd498d05e26e63ec9a892cdd4d15313beeaaa13b8729f473996a935c0"
    static let clientSecret = "e85e3a829dd13c5bbd64c22c00c4506ea1d138fd46efe3edd6797ef3b1f02e0e"
    static let stuartBaseUrl = "https://sandbox-api.stuart.com/"
/*#else
    // Production
    static let clientID = "129ecc7ce31890931d8e3bb5223cd202f77fd51ca8d74eb980aad46649a0db35"
    static let clientSecret = "db27ec6b74620bab341c72941af1b48c222924bd8aa583b946480a01f18b19db"
    static let stuartBaseUrl = "https://api.stuart.com/"
#endif*/

    static var authToken: String?

}
