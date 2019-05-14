import Stripe

struct StripeService {

    static let publicKey = "pk_test_27giqgLSvi80jxgWeGwEzg6Y000sjrXr9y"
    static let secretKey = "sk_test_BiHsepXoSf1E0uLZcpJvqiLX00PcxLHLyP"
    static let clientId = "ca_F1vuvYuSwP0KpRWrX8lHZiTEKUajjT5B"
    static let apiVersion = "2019-03-14"

    // Check chef connection response
    static let chefConnectionUrl = "https://toqueat.com/chef-connected"

    static var ephemeralKey: String?
    static var customerContext: STPCustomerContext?

    static func setCustomerContext() {
        customerContext = STPCustomerContext(keyProvider: NetworkService.shared)
    }

}
